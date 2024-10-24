/*
/// Module: unswap2
module unswap2::unswap2 {

}
*/

//uniswap2
//1 uniswapV1主要提供各种ERC20 token与ETH互相兑换的途径，以ETH为交易中心来实现ERC20 token与ERC20 token之间的兑换。
//Uniswap V1的兑换方式就是先计算出来1g黄金能换多少美元，再把换出的美元拿去购买白银。

// uv2就是没有中介货币，直接兑换
// 提供了一个更强的价格预言机，在每个块的开头计算两个资产的相对价格--这个做不到
// 可以理解为交易所每时每分都在为你更新现在1g黄金对比多少白银
//支持闪电交换(Flash swap)，即闪电贷，用户可以免费的获得这些资产并在链上使用它们，只需要在交易结束后归还这些资产

//闪电贷

//恒定乘积公式 x*y=k
//
module  unswap2::swap{
    use sui::balance;
    use sui::balance::Balance;
    use sui::coin::into_balance;
    use sui::object;
    use sui::object::UID;
    use sui::token;
    use sui::token::sender;
    use sui::transfer::{share_object, public_transfer};
    use sui::tx_context::TxContext;
    use coins::coin_b::COIN_B;
    use coins::coin_a::COIN_A;
    use coins::coin_b;
    use coins::coin_a;
    //初始化k为1万
    //COIN_A * COIN_B =1W
  const  Total :u64=10000;

    //池子
    public struct Unswap<phantom COIN_A, phantom COIN_B> has key,store{
    id:UID,
    A:Balance<COIN_A>,
    B:Balance<COIN_B>,
}
    // public  struct Admin has ket,store{
    //     id:UID,
    // }
    //交易所A
    public  struct DexA<phantom COIN_A,phantom COIN_B> has key ,store{
        id:UID,
        A:Balance<COIN_A>,
        B:Balance<COIN_B>,
    }


    //交易所B
    public  struct DexB<phantom COIN_A,phantom COIN_B> has key ,store{
        id:UID,
        A:Balance<COIN_A>,
        B:Balance<COIN_B>,
    }
    //借款人
    public struct Admin <phantom COIN_A,phantom COIN_B>has key,store{
        id:UID,
        A:Balance<COIN_A>,
        B:Balance<COIN_B>,
    }
    //初始化
    fun init (ctx:&mut TxContext){
        let univ2 = Unswap<COIN_A,COIN_B>{
            id:object::new(ctx),
            A:balance::zero(),
            B:balance::zero(),
        };
        let admin = Admin<COIN_A,COIN_B>{
            id:object::new(ctx),
            A:balance::zero(),
            B:balance::zero(),
        };
        let dexA =DexA<COIN_A,COIN_B>{
            id:object::new(ctx),
            A:balance::zero(),
            B:balance::zero(),
        };
        let dexB =DexA<COIN_A,COIN_B>{
            id:object::new(ctx),
            A:balance::zero(),
            B:balance::zero(),
        };
        //所有权转移
        share_object(univ2);
        public_transfer(admin,ctx.sender());
        //交易所是公共的
        share_object(dexA);
        share_object(dexB);
    }
    //闪电贷
    //在同一个交易里面，借钱，操作，还钱，如果不赚钱，直接回滚
    //借钱，还钱：人，交易所A(已准备)
    //操作：交易所B 人（已准备）
    //操作对象：COIN （已准备）

   //传入交易所，借钱数量
   //在另一个交易所高价卖出
    public  entry  fun fl(dex_a:&mut DexA<COIN_A,COIN_B>,dex_b:&mut DexB<COIN_A,COIN_B>,amt:u64,admin:&mut Admin<COIN_A,COIN_B>,ctx:&mut TxContext){
       //从A交易所借钱
       let brrow_money = balance::split(&mut dex_a.A,amt);
       //给借款人
       admin.A.join(brrow_money);
       //我现在拥有的B的数量
       let own_money = balance::value(&admin.B);
       //现在我在B交易所卖掉A,得到COINB
       let sold_A= balance::split(&mut admin.A,amt);
       dex_b.A.join(sold_A);

       let earn_money = balance::split(&mut dex_b.B,amt*2);
       admin.B.join(earn_money);

       //比较我是否赚钱
       let own_money_2 =balance::value(&admin.B);

       if (own_money>= own_money_2){
           abort (0);
       };

       //还钱给A交易所
       //1 将COIN_B换成COIN_A
       let huan_coin_b= balance::split(&mut admin.B,amt*3/2);
        dex_a.B.join(huan_coin_b);

       let h = balance::split(&mut dex_a.A,amt);
       balance::join(&mut admin.A,h);
       //开始还钱
       let huan_= balance::split(&mut admin.A,amt);
       dex_a.A.join(huan_);

   }
    //change 汇率收钱
    public entry  fun swap(bank:&mut DexA<COIN_A,COIN_B>,bank2:&mut DexB<COIN_A,COIN_B>,people:&mut Admin<COIN_A,COIN_B>,amt:u64){
        //people 要用 amt数量的tokenA换tokenB,手续费是千分之三
        // 1 获取彼此的余额
        let people_own = balance::value(&people.A);
        let dex_value =balance::value(&bank.B);

        //假设收以people的token_a为手续费
       if(people_own<=amt){
           abort (0);
       };
        let true_amt = amt*997/1000;
        let shou_xu = amt*3/1000;
        //开始转换
        if(dex_value < true_amt*3/2){
            abort (0)
        };
        let true_cbalanze = balance::split(&mut people.A,true_amt);
        let shou_cbalanze = balance::split(&mut people.A,shou_xu);

        //收手续费
        bank2.A.join(shou_cbalanze);

        //开始转移
         bank.A.join(true_cbalanze);

        let transfert_balance = balance::split(&mut bank.B,true_amt*3/2);

        people.B.join(transfert_balance);




    }


}
