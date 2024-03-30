package whitelistfactory

import (
	"bytes"
	"std"
	"strconv"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
	whitelist "gno.land/p/leon/test/test/whitelist" // Change to your deployed whitelist package path
)

// State variables
var (
	whitelistTree *avl.Tree
)

// Constructor
func init() {
	whitelistTree = avl.NewTree()
}

// Creates new whitelist instance
// @param name - name of new whitelist instance
// @param deadline - deadline for signing up to whitelist, in unix seconds
// @param maxUsers - maximum number of users allowed to sign up to deadlist
// @return - ID of whitelist, status message
func NewWhitelist(name string, deadline int, maxUsers int) string {
	// Check if deadline is in the past
	if deadline <= int(std.GetHeight()) {
		panic("deadline cannot be in the past")
	}

	// Get user who sent the transaction
	txSender := std.GetOrigCaller()

	// We will use the current size of the tree for the ID
	id := strconv.Itoa(whitelistTree.Size())

	if maxUsers <= 0 {
		panic("maximum number of users cannot be less than 1")
	}

	// Create new whitelist instance
	w := whitelist.NewWhitelist(name, deadline, maxUsers, txSender)

	// Update AVL tree with new state
	whitelistTree.Set(id, w)
	return id
}

// Signs up txSender to whitelist
// @param whitelistID - ID of whitelist to sign up to
// @return - status message
func SignUpToWhitelist(whitelistID int) string {
	// Get ID and convert to string
	id := strconv.Itoa(whitelistID)

	// Get txSender
	txSender := std.GetOrigCaller()

	// Try to get specific whitelist from AVL tree
	// Note: AVL tree keys are of the string type
	whiteListRaw, exists := whitelistTree.Get(id)

	if !exists {
		panic("whitelist does not exist")
	}

	// Cast raw Tree data into "Whitelist" type
	w, _ := whiteListRaw.(*whitelist.Whitelist)

	ddl := w.GetWhitelistDeadline()

	// error handling
	if w.IsOnWhitelist(txSender) {
		panic("user already in whitelist")
	}

	// If deadline has passed
	if ddl <= int(std.GetHeight()) {
		panic("whitelist already closed")
	}

	// If whitelist is full
	if w.GetMaxUsers() <= len(w.GetWhitelistedUsers()) {
		panic("whitelist full")
	}

	// Add txSender to user list
	w.AddUserToList(txSender)

	// Update the AVL tree with new state
	whitelistTree.Set(id, w)
	return "successfully signed up to " + id
}

// Default render function
func Render(path string) string {
	if path == "" {
		return renderHomepage()
	}

	return "unknown page"
}

// Renders all whitelists with their details
func renderHomepage() string {
	// Define empty buffer
	var b bytes.Buffer

	b.WriteString("# Sign up to a Whitelist\n\n")

	// If no whitelists have been created
	if whitelistTree.Size() == 0 {
		b.WriteString("### No whitelists available currently!")
		return b.String()
	}

	// Iterate through AVL tree
	whitelistTree.Iterate("", "", func(key string, value interface{}) bool {

		// cast raw data from tree into Whitelist struct
		w := value.(*whitelist.Whitelist)
		ddl := w.GetWhitelistDeadline()

		// Add whitelist name
		b.WriteString(
			ufmt.Sprintf(
				"## Whitelist #%s: %s\n",
				key, // whitelist ID
				w.GetWhitelistName(),
			),
		)

		// Check if whitelist deadline is past due
		if ddl > int(std.GetHeight()) {
			b.WriteString(
				ufmt.Sprintf(
					"Whitelist sign-ups close at block %d\n\n",
					w.GetWhitelistDeadline(),
				),
			)
		} else {
			b.WriteString(
				ufmt.Sprintf(
					"Whitelist sign-ups closed!\n\n",
				),
			)
		}

		// List max number of users in waitlist
		b.WriteString(
			ufmt.Sprintf(
				"Maximum number of users in whitelist: %d\n\n",
				w.GetMaxUsers(),
			),
		)

		// List all users that are currently whitelisted
		if users := w.GetWhitelistedUsers(); len(users) > 0 {
			b.WriteString(
				ufmt.Sprintf("Currently whitelisted users: %d\n\n", len(users)),
			)

			for index, user := range users {
				b.WriteString(
					ufmt.Sprintf("#%d - %s  \n", index, user),
				)
			}
		} else {
			b.WriteString("No addresses are whitelisted currently\n")
		}

		b.WriteString("\n")
		return false
	})

	return b.String()
}

// Tutorial: From Zero to Gno.land Hero - Updated 30th of March 2024
