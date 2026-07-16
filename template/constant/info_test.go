/*
 * This file is part of the Valkyrja Framework package.
 *
 * (c) Melech Mizrachi <melechmizrachi@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

// Tests live in an external `_test` package and are co-located with the source
// they cover — the Go convention. Reusable doubles belong in a `fixtures`
// package named `*Fixture`, never `*Test`.
package constant_test

import (
	"testing"

	"github.com/valkyrjaio/project-template-go/v26/template/constant"
)

func TestVersionIsSet(t *testing.T) {
	t.Parallel()

	if constant.Version == "" {
		t.Error("Version must not be empty")
	}
}

func TestVersionBuildDateTimeIsSet(t *testing.T) {
	t.Parallel()

	if constant.VersionBuildDateTime == "" {
		t.Error("VersionBuildDateTime must not be empty")
	}
}
