package com.seielika.reportapp.Data

data class ReportContent(
    var id: Int,
    var dateTime: String,
    var reportDetail: List<ReportDetail>,
    var imageDetail: List<ImageDetail>
)

data class ReportDetail(
    var id: Int,
    var content: String
)

data class ImageDetail(
    var id: Int,
    var imgPath: String
)