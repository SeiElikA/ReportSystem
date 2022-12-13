package com.seielika.reportapp.Model

import android.graphics.Bitmap
import android.media.MediaMetadataRetriever.BitmapParams
import com.bumptech.glide.util.pool.GlideTrace
import com.google.gson.Gson
import com.seielika.reportapp.Data.Login
import com.seielika.reportapp.Data.Report
import com.seielika.reportapp.Global
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.ByteArrayOutputStream
import java.time.Duration

class AddReportModel {
    fun sendReport(report: Report, callBack: Callback) {
        val body = Gson().toJson(report)
        val requestBody = body.toRequestBody()

        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .method("POST", requestBody)
            .header("Content-Type", "application/json")
            .url(Global.baseURL + "sendReport")
            .build()

        client.newCall(request).enqueue(callBack)
    }


    fun sendImage(reportId: Int, imgList: List<Bitmap>, callBack: Callback) {
        val multipartBody = MultipartBody.Builder()
            .setType(MultipartBody.FORM)
        imgList.forEach {
            val outputStream = ByteArrayOutputStream()
            it.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)
            multipartBody.addFormDataPart("image", "fileName", outputStream.toByteArray().toRequestBody("image/jpg".toMediaType()))
        }
        multipartBody.build()

        val client = OkHttpClient.Builder()
            .connectTimeout(Duration.ofSeconds(10))
            .build()

        val request = Request.Builder()
            .post(multipartBody.build())
            .url(Global.baseURL + "uploadImg?reportId=$reportId")
            .build()

        client.newCall(request).enqueue(callBack)
    }
}