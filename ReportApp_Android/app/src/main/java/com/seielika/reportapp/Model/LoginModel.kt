package com.seielika.reportapp.Model

import android.content.Context
import androidx.core.content.edit
import com.google.gson.Gson
import com.seielika.reportapp.Data.Login
import com.seielika.reportapp.Data.LoginResponse
import com.seielika.reportapp.Global
import okhttp3.*
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException
import java.time.Duration

class LoginModel {
    fun login(email: String, password: String, callBack: Callback) {
        val body = Login(email, password)
        val requestBody = Gson().toJson(body).toRequestBody()

        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .method("POST", requestBody)
            .header("Content-Type", "application/json")
            .url(Global.baseURL + "login")
            .build()

        client.newCall(request).enqueue(callBack)
    }

    fun saveLoginInfo(context: Context, login: LoginResponse) {
        val sharedPreferences = context.getSharedPreferences("User", Context.MODE_PRIVATE)
        sharedPreferences.edit {
            putInt("id", login.id)
            putString("name", login.name)
            putString("email", login.email)
            putString("password", login.password)
            putBoolean("isLogin", true)
        }
    }
}