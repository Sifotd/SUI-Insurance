/*
/// Module: baoxian
module baoxian::baoxian {

}
*/
module baoxian::jiabao{

    use sui::balance::Balance;

    //货款流入池子中时的商品价格
    public  struct  Pool <phantom SUI>has key,store{
         id:UID,
         balance:Balance<SUI>,//池子中的钱
     }

    //当前的价格
    public struct Product has key,store{
        id:UID,
        price:u64,
    }
    public  fun return_price_difference(product:& Product,ctx:&mut TxContext){


    }
}