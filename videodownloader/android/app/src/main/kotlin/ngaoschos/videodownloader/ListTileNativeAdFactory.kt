package ngaoschos.videodownloader

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

internal class ListTileNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {



    override fun createNativeAd(
            nativeAd: NativeAd, customOptions: Map<String?, Any?>?): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
                .inflate(R.layout.list_tile_native_ad, null) as NativeAdView
        val attributionViewSmall = nativeAdView
                .findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_small)
        val attributionViewLarge = nativeAdView
                .findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_large)
        val iconView = nativeAdView.findViewById<ImageView>(R.id.iv_list_tile_native_ad_icon)
        val icon = nativeAd.icon
        if (icon != null) {
            attributionViewSmall.visibility = View.VISIBLE
            attributionViewLarge.visibility = View.INVISIBLE
            iconView.setImageDrawable(icon.drawable)
        } else {
            attributionViewSmall.visibility = View.INVISIBLE
            attributionViewLarge.visibility = View.VISIBLE
        }
        nativeAdView.setIconView(iconView)
        val headlineView = nativeAdView.findViewById<TextView>(R.id.tv_list_tile_native_ad_headline)
        headlineView.text = nativeAd.headline
        nativeAdView.setHeadlineView(headlineView)
        val bodyView = nativeAdView.findViewById<TextView>(R.id.tv_list_tile_native_ad_body)
        bodyView.text = nativeAd.body
        bodyView.visibility = if (nativeAd.body != null) View.VISIBLE else View.INVISIBLE
        nativeAdView.setBodyView(bodyView)
        nativeAdView.setNativeAd(nativeAd)
        return nativeAdView
    }
}
