package com.seielika.reportapp.Model

import com.google.gson.Gson
import com.seielika.reportapp.Global
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.time.Duration

class AdminModel {
    // selection low task account, and detect mode use to decide auto or manual selection
    public fun getDetectMode(callback: Callback) {
        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .url(Global.baseURL + "getDetectMode")
            .build()

        client.newCall(request).enqueue(callback)
    }

    fun setMode(mode: Int, callback: Callback) {
        val body = JSONObject().put("mode", mode).toString()

        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .post(body.toRequestBody())
            .url(Global.baseURL + "setDetectMode")
            .header("content-type", "application/json")
            .build()

        client.newCall(request).enqueue(callback)
    }

    fun getAccountList(callback: Callback) {
        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .url(Global.baseURL + "getAccount")
            .build()

        client.newCall(request).enqueue(callback)
    }

    fun getTodayTaskList(callback: Callback) {
        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .url(Global.baseURL + "getTodayReport")
            .build()

        client.newCall(request).enqueue(callback)
    }

    fun setLowTaskAccount(accountID: Int, callback: Callback) {
        val body = JSONObject().put("accountId", accountID).toString()

        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .post(body.toRequestBody())
            .url(Global.baseURL + "setLowTaskAccount")
            .header("content-type", "application/json")
            .build()

        client.newCall(request).enqueue(callback)
    }
}