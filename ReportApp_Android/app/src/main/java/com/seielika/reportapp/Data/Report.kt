package com.seielika.reportapp.Data

data class Report(var data: List<ReportSend>, var accountId: Int)

data class ReportSend(var content: String)