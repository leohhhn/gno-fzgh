package whitelist

import (
	"std"
	"testing"
	"time"

	"gno.land/p/demo/testutils"
)

func TestWhitelist_Setup(t *testing.T) {
	var (
		name     = "first whitelist!"
		deadline = time.Now().Add(15)
		maxUsers = 100
	)

	alice := testutils.TestAddress("alice")

	w := NewWhitelist(name, deadline, int64(maxUsers), alice)

	if w.GetWhitelistOwner() != alice {
		t.Fatal("invalid whitelist owner")
	}

	if w.GetMaxUsers() != maxUsers {
		t.Fatal("invalid max user number")
	}

	if w.GetWhitelistDeadline() != deadline {
		t.Fatal("invalid deadline")
	}

	if len(w.GetWhitelistedUsers()) != 0 {
		t.Fatal("invalid whitelisted user list")
	}
}