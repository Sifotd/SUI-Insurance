/*
/// Module: coins
module coins::coins {

}
*/
module coins::coin_a{
    use std::option;
    use coins::coin_b;
    use sui::coin;
    use sui::coin::{mint_and_transfer, TreasuryCap};
    use sui::transfer::{public_share_object, public_freeze_object};
    use sui::tx_context::TxContext;

    public struct COIN_A has drop{}

    fun init (witness:COIN_A,ctx:&mut TxContext){
        let (traCap_a,coin_a) = coin::create_currency(witness,6,b"for_swap",b"coin_a",b"one_object", option::none(),ctx);
        public_freeze_object(coin_a);
        public_share_object(traCap_a);

    }
   public entry fun mint_and_send(trap:&mut TreasuryCap<COIN_A>,am:u64,recive:address,ctx:&mut TxContext){
       mint_and_transfer(trap,am,recive,ctx);
   }

}