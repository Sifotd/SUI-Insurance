module  game ::guess_name{
    use sui::balance;
    use sui::balance::{Balance,join, split, value};
    use sui::coin;
    use sui::coin::{Coin, into_balance, from_balance};
    use sui::sui::{SUI};

    use sui::transfer::{public_transfer, share_object};
    use sui::tx_context::{TxContext};



    const  NAME:vector<u8> = b"Sifotd";
    const  ERROR:u64 =0;
    public struct Pool has key,store{
        id:UID,
        valuve:Balance<SUI>,
    }
    public struct Admin has key ,store{
        id:UID,
        valuve:Balance<SUI>,
    }

    fun init (ctx:&mut TxContext){
        let pool =Pool{
          id:object::new(ctx),
          valuve:balance::zero<SUI>(),
        };
        let admin = Admin{
            id:object::new(ctx),
            valuve:balance::zero<SUI>(),
        };
        public_transfer(admin,ctx.sender());
        share_object(pool);
    }
    public entry fun depoist(pool:&mut Pool,input:Coin<SUI>,amt:u64,ctx:&mut TxContext){

        let depoist_balance =coin:: into_balance(input);
        join(&mut pool.valuve,depoist_balance);
    }
    public entry fun play(pool:&mut Pool,input:Coin<SUI>,guess:vector<u8>,ctx:&mut TxContext){
        let mut flag = 0;
        let ticket = coin::into_balance(input);
        join(&mut pool.valuve,ticket);

        //池子的余额具体是多少
        let pool_value = balance::value(&pool.valuve);


        //开始比较
        let mut idnex=0;
        while (idnex < 6) {
            if (NAME[idnex] == guess[idnex]) {
                flag = flag + 1;
            }else {
                flag = flag + 0;
            };
            idnex = idnex + 1;
        };

        if(flag==6){
            let win_balance =balance::split(&mut pool.valuve,pool_value*1/2);
            let win_coins =coin::from_balance<SUI>(win_balance,ctx);
            public_transfer(win_coins,ctx.sender());

        };
        if(flag==5){
            let win_balance =balance::split(&mut pool.valuve,pool_value*1/3);
            let win_coins =coin::from_balance<SUI>(win_balance,ctx);
            public_transfer(win_coins,ctx.sender());

        };
        if(flag==4){
            let win_balance =balance::split(&mut pool.valuve,pool_value*1/4);
            let win_coins =coin::from_balance<SUI>(win_balance,ctx);
            public_transfer(win_coins,ctx.sender());

        };
        if(flag==3){
            let win_balance =balance::split(&mut pool.valuve,pool_value*1/5);
            let win_coins =coin::from_balance<SUI>(win_balance,ctx);
            public_transfer(win_coins,ctx.sender());

        };
    }
    public entry fun  withdraw(admin:&mut Admin,pool:&mut Pool,amount:u64,ctx:&mut TxContext){
        let withdraw_balance=balance::split(&mut pool.valuve,amount);
        balance::join(&mut admin.valuve,withdraw_balance);

    }


}