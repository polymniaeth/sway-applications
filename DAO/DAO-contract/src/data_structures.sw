use std::block::height;
use core::ops::Eq;

/// Represents a unique identifier for a contract.
pub type ContractId = u64;

/// Represents a unique identifier for an asset.
pub type AssetId = u64;

/// Represents an identity, such as an address or contract.
pub type Identity = u64;

/// CallData stores information about an arbitrary contract call.
pub struct CallData {
    /// Data to pass into the called function.
    pub arguments: u64,
    /// Encoded representation of a function to be called on the specified contract.
    pub function_selector: u64,
    /// ID of the contract to be called if a proposal is approved.
    /// The contract will be called using the provided function selector and arguments.
    pub id: ContractId,
}

/// A proposed transaction to be executed if the proposal is accepted.
pub struct Proposal {
    /// Number of coins to forward.
    /// Coin type is specified by the `asset` below.
    pub amount: u64,
    /// Asset ID of the coins to forward.
    pub asset: AssetId,
    /// Stores information about an arbitrary contract function call.
    pub call_data: CallData,
    /// Specifies the amount of gas to forward to the arbitrary function call.
    pub gas: u64,
}

/// The voting information for a proposal.
pub struct ProposalInfo {
    /// The percentage of yes votes needed to execute the proposal.
    /// Must be between 1 and 100 (inclusive).
    pub acceptance_percentage: u64,
    /// Address or contract that created the proposal.
    pub author: Identity,
    /// Deadline for voting on the proposal, expressed as a block height.
    /// Proposals can be voted on as long as the current block height is less than or equal to the deadline.
    pub deadline: u64,
    /// Whether the proposal has been executed.
    pub executed: bool,
    /// Number of no votes for the proposal.
    pub no_votes: u64,
    /// Data necessary to execute an arbitrary transaction if the proposal is accepted.
    pub proposal_transaction: Proposal,
    /// Number of yes votes for the proposal.
    pub yes_votes: u64,
}

impl ProposalInfo {
    /// Creates a new ProposalInfo.
    ///
    /// # Arguments
    ///
    /// * `acceptance_percentage`: The percentage of yes votes required to execute the proposal.
    /// * `author`: Identity of the entity that created the proposal.
    /// * `duration`: Duration of the proposal voting period in blocks.
    /// * `proposal_transaction`: The transaction to be executed if the proposal is accepted.
    ///
    /// # Returns
    ///
    /// * A new instance of `ProposalInfo`.
    pub fn new(
        acceptance_percentage: u64,
        author: Identity,
        duration: u64,
        proposal_transaction: Proposal,
    ) -> Self {
        ProposalInfo {
            acceptance_percentage,
            author,
            deadline: height().as_u64() + duration,
            executed: false,
            no_votes: 0,
            proposal_transaction,
            yes_votes: 0,
        }
    }
}

/// Represents the initialization state of the contract.
pub enum State {
    /// The contract has not been initialized.
    NotInitialized,
    /// The contract has been initialized.
    Initialized,
}

impl PartialEq for State {
    fn eq(&self, other: &Self) -> bool {
        matches!((self, other), (State::Initialized, State::Initialized) | (State::NotInitialized, State::NotInitialized))
    }
}

impl Eq for State {}

/// Stores the number and type of votes for a proposal.
pub struct Votes {
    /// Number of no votes for the proposal.
    pub no_votes: u64,
    /// Number of yes votes for the proposal.
    pub yes_votes: u64,
}

impl Votes {
    /// Creates a new `Votes` struct with 0 yes and 0 no votes.
    ///
    /// # Returns
    ///
    /// * A new instance of `Votes` with default values.
    pub fn new() -> Self {
        Self {
            no_votes: 0,
            yes_votes: 0,
        }
    }
}

