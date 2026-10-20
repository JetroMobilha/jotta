package com.example.jota

import android.app.Activity
import android.os.Bundle

class ComposeSmsActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // This is a stub activity required to be a Default SMS app.
        // We just close it immediately.
        finish()
    }
}
