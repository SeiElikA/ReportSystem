package com.seielika.reportapp.Model

import android.content.Context
import androidx.core.content.edit
import com.google.gson.Gson
import com.seielika.reportapp.Data.Login
import com.seielika.reportapp.Global
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.time.Duration

class MainModel {
    public fun clearLoginInfo(context: Context) {
        context.getSharedPreferences("User", Context.MODE_PRIVATE).edit {
            clear()
        }
    }

    public fun fetchReportContent(accountId: Int, callBack: Callback) {
        val body = JSONObject().put("accountId", accountId).toString()
        val requestBody = body.toRequestBody()

        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .method("POST", requestBody)
            .header("Content-Type", "application/json")
            .url(Global.baseURL + "getReport")
            .build()

        client.newCall(request).enqueue(callBack)
    }
}