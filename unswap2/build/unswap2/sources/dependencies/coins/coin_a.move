/*
/// Module: coins
module coins::coins {

}
*/
module coins::coin_a{
    use std::option;
    use sui::coin;
    use sui::transfer::{public_share_object, public_freeze_object};
    use sui::tx_context::TxContext;

    public struct COIN_A has drop{}

    fun init (witness:COIN_A,ctx:&mut TxContext){
        let (traCap_a,coin_a) = coin::create_currency(witness,6,b"for_swap",b"coin_a",b"one_object", option::none(),ctx);
        public_freeze_object(coin_a);
         public_share_object(traCap_a);

    }
}