package com.seielika.reportapp.Data

import com.google.gson.annotations.SerializedName

data class AdminReport(
    @SerializedName("account") var account: Account? = Account(),
    @SerializedName("reportDetail") var reportDetail: ArrayList<ReportDetail> = arrayListOf(),
    @SerializedName("imageDetail") var imageDetail: ArrayList<ImageDetail> = arrayListOf()
)

data class Account(
    @SerializedName("id") var id: Int? = null,
    @SerializedName("name") var name: String? = null,
    @SerializedName("email") var email: String? = null,
    @SerializedName("password") var password: String? = null
)