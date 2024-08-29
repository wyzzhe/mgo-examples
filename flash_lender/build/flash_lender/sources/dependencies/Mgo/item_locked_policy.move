// Copyright (c) MangoNet Labs Ltd.
// SPDX-License-Identifier: Apache-2.0

#[test_only]
/// A Policy that makes sure an item is placed into the `Kiosk` after `purchase`.
/// `Kiosk` can be any.
module mgo::item_locked_policy {
    use mgo::kiosk::{Self, Kiosk};
    use mgo::transfer_policy::{
        Self as policy,
        TransferPolicy,
        TransferPolicyCap,
        TransferRequest
    };

    /// Item is not in the `Kiosk`.
    const ENotInKiosk: u64 = 0;

    /// A unique confirmation for the Rule
    struct Rule has drop {}

    public fun set<T>(policy: &mut TransferPolicy<T>, cap: &TransferPolicyCap<T>) {
        policy::add_rule(Rule {}, policy, cap, true)
    }

    /// Prove that an item a
    public fun prove<T>(request: &mut TransferRequest<T>, kiosk: &Kiosk) {
        let item = policy::item(request);
        assert!(kiosk::has_item(kiosk, item) && kiosk::is_locked(kiosk, item), ENotInKiosk);
        policy::add_receipt(Rule {}, request)
    }
}
