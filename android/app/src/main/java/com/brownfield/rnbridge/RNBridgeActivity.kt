package com.brownfield.rnbridge

import android.os.Bundle
import android.view.KeyEvent
import androidx.appcompat.app.AppCompatActivity
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactRootView
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler

/**
 * Base Activity for hosting React Native views in a brownfield Android app.
 * 
 * Extend this activity or use it directly to display React Native content.
 * It handles the React Native lifecycle and hardware back button.
 * 
 * Usage in navigation:
 * ```kotlin
 * val intent = Intent(this, RNBridgeActivity::class.java).apply {
 *     putExtra(RNBridgeActivity.EXTRA_MODULE_NAME, "BrownfieldScreen")
 *     putExtra(RNBridgeActivity.EXTRA_INITIAL_PROPS, bundleOf("title" to "My Screen"))
 * }
 * startActivity(intent)
 * ```
 */
open class RNBridgeActivity : AppCompatActivity(), DefaultHardwareBackBtnHandler {
    
    companion object {
        const val EXTRA_MODULE_NAME = "module_name"
        const val EXTRA_INITIAL_PROPS = "initial_props"
        
        private const val DEFAULT_MODULE_NAME = "BrownfieldScreen"
    }
    
    private var reactRootView: ReactRootView? = null
    private val reactInstanceManager: ReactInstanceManager?
        get() = RNBridgeManager.getReactInstanceManager()
    
    /**
     * The name of the React Native component to display.
     * Override this or pass via intent extra.
     */
    protected open val moduleName: String
        get() = intent.getStringExtra(EXTRA_MODULE_NAME) ?: DEFAULT_MODULE_NAME
    
    /**
     * Initial properties to pass to the React Native component.
     * Override this or pass via intent extra.
     */
    protected open val initialProps: Bundle?
        get() = intent.getBundleExtra(EXTRA_INITIAL_PROPS)
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        if (!RNBridgeManager.isReady()) {
            finish()
            return
        }
        
        reactRootView = ReactRootView(this).apply {
            startReactApplication(
                reactInstanceManager,
                moduleName,
                initialProps
            )
        }
        
        setContentView(reactRootView)
    }
    
    override fun onPause() {
        super.onPause()
        reactInstanceManager?.onHostPause(this)
    }
    
    override fun onResume() {
        super.onResume()
        reactInstanceManager?.onHostResume(this, this)
    }
    
    override fun onDestroy() {
        super.onDestroy()
        reactRootView?.unmountReactApplication()
        reactRootView = null
    }
    
    override fun onBackPressed() {
        reactInstanceManager?.let { manager ->
            manager.onBackPressed()
            return
        }
        super.onBackPressed()
    }
    
    override fun invokeDefaultOnBackPressed() {
        super.onBackPressed()
    }
    
    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            reactInstanceManager?.showDevOptionsDialog()
            return true
        }
        return super.onKeyUp(keyCode, event)
    }
}
