package com.brownfield.rnbridge

import android.content.Context
import android.os.Bundle
import android.util.AttributeSet
import android.widget.FrameLayout
import com.facebook.react.ReactRootView

/**
 * A custom View that hosts a React Native component.
 * 
 * Use this view to embed React Native content within existing Android layouts.
 * It can be used in XML layouts or created programmatically.
 * 
 * XML Usage:
 * ```xml
 * <com.brownfield.rnbridge.RNBridgeView
 *     android:id="@+id/react_view"
 *     android:layout_width="match_parent"
 *     android:layout_height="match_parent"
 *     app:moduleName="BrownfieldScreen" />
 * ```
 * 
 * Programmatic Usage:
 * ```kotlin
 * val rnView = RNBridgeView(context).apply {
 *     setModuleName("BrownfieldScreen")
 *     setInitialProps(bundleOf("title" to "My Screen"))
 *     startReactApplication()
 * }
 * container.addView(rnView)
 * ```
 */
class RNBridgeView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : FrameLayout(context, attrs, defStyleAttr) {
    
    private var reactRootView: ReactRootView? = null
    private var moduleName: String = "BrownfieldScreen"
    private var initialProps: Bundle? = null
    private var isStarted = false
    
    init {
        // Parse custom attributes if needed
        attrs?.let {
            // Custom attribute parsing can be added here
        }
    }
    
    /**
     * Sets the name of the React Native component to display
     */
    fun setModuleName(name: String) {
        moduleName = name
    }
    
    /**
     * Sets the initial properties to pass to the React Native component
     */
    fun setInitialProps(props: Bundle?) {
        initialProps = props
    }
    
    /**
     * Starts the React Native application within this view.
     * Call this after setting moduleName and initialProps.
     */
    fun startReactApplication() {
        if (isStarted || !RNBridgeManager.isReady()) {
            return
        }
        
        reactRootView = ReactRootView(context).apply {
            layoutParams = LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT
            )
            startReactApplication(
                RNBridgeManager.getReactInstanceManager(),
                moduleName,
                initialProps
            )
        }
        
        addView(reactRootView)
        isStarted = true
    }
    
    /**
     * Stops and cleans up the React Native application.
     * Call this when the view is no longer needed.
     */
    fun stopReactApplication() {
        reactRootView?.unmountReactApplication()
        removeView(reactRootView)
        reactRootView = null
        isStarted = false
    }
    
    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        stopReactApplication()
    }
}
