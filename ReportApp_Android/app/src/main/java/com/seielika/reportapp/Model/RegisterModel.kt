package com.seielika.reportapp.Model

import com.google.gson.Gson
import com.seielika.reportapp.Data.Login
import com.seielika.reportapp.Data.Register
import com.seielika.reportapp.Global
import okhttp3.Callback
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.time.Duration

class RegisterModel {
    fun register(register: Register, callBack: Callback) {
        val requestBody = Gson().toJson(register).toRequestBody()

        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .method("POST", requestBody)
            .header("Content-Type", "application/json")
            .url(Global.baseURL + "signUp")
            .build()

        client.newCall(request).enqueue(callBack)
    }
}