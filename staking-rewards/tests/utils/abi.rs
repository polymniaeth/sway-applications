use core::fmt::Debug;
use fuels::{
    core::traits::Tokenizable,
    prelude::*,
    programs::{call_response::FuelCallResponse, contract::ContractCallHandler},
    types::{Identity, SizedAsciiString},
    // tx::UniqueIdentifier,
    // types::transaction_response::TransactionStatus,
};

use crate::utils::StakingRewards;

use super::STAKING_ASSET;

pub async fn balance_of(instance: &StakingRewards, id: &Identity) -> u64 {
    instance.methods().balance_of(id.to_owned()).call().await.unwrap().value
}

pub async fn earned(instance: &StakingRewards, wallet_identity: Identity) -> u64 {
    instance.methods().earned(wallet_identity).call().await.unwrap().value
}

pub async fn reward_per_token(instance: &StakingRewards) -> u64 {
    instance.methods().reward_per_token().call().await.unwrap().value
}

pub async fn reward_per_token_stored(instance: &StakingRewards) -> u64 {
    instance.methods().reward_per_token_stored().call().await.unwrap().value
}

pub async fn stake(instance: &StakingRewards, amount: u64) -> FuelCallResponse<()> {
    instance
        .methods()
        .stake()
        .call_params(CallParameters {
            amount,
            asset_id: STAKING_ASSET,
            gas_forwarded: Some(1000000),
        })
        .call()
        .await
        .unwrap()
}

pub async fn notify_reward_amount(instance: &StakingRewards, reward: u64) -> FuelCallResponse<()> {
    instance
        .methods()
        .notify_reward_amount(reward)
        .call()
        .await
        .unwrap()
}