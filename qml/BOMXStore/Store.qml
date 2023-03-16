/* it's important for one js storage*/
pragma Singleton

import QtQml 2.3
import './BOMXStore.js' 1.0 as JS // WARNING: not include\import it in other places - js locals be destructed
// see usage in complex in test.qml

QtObject {
	readonly property var store: JS.store
	readonly property var view: JS.view
}
