module coins::coin_b{
    use std::option;
    use coins::coin_a;
    use sui::coin;
    use sui::coin::{mint_and_transfer,TreasuryCap};
    use sui::transfer::{public_share_object,public_freeze_object};
    use sui::tx_context::TxContext;

    public struct COIN_B has drop{}

    fun init (witness:COIN_B,ctx:&mut TxContext){
        let (traCap_b,coin_b) = coin::create_currency(witness,6,b"for_swap",b"coin_b",b"one_object", option::none(),ctx);
        public_freeze_object(coin_b);
        public_share_object(traCap_b);


    }
    public entry fun mint_and_send(trap:&mut TreasuryCap<COIN_B>,am:u64,recive:address,ctx:&mut TxContext){
        mint_and_transfer(trap,am,recive,ctx);
    }

//初始化之后不能 mint_and_transfer
}