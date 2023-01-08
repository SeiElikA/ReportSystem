package com.seielika.reportapp.View

import android.R
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.MenuItem
import androidx.core.view.isVisible
import com.bumptech.glide.Glide
import com.seielika.reportapp.Data.ReportContent
import com.seielika.reportapp.Global
import com.seielika.reportapp.databinding.ActivityReportDetailBinding
import com.seielika.reportapp.databinding.ItemImgItemBinding
import com.seielika.reportapp.databinding.ItemWorkItemBinding

class ReportDetailActivity : AppCompatActivity() {
    private lateinit var control: ActivityReportDetailBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        control = ActivityReportDetailBinding.inflate(layoutInflater)
        setContentView(control.root)
        title = "Report Detail"
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        val data = intent.getSerializableExtra("data") as ReportContent
        data.reportDetail.map { it.content }.forEachIndexed { index, s ->
            val item = ItemWorkItemBinding.inflate(layoutInflater)
            item.txtItem.text = "${index + 1}. $s"
            item.btnClose.isVisible = false
            control.layoutWorkItem.addView(item.root)
        }

        if(data.imageDetail.isEmpty()) {
            control.txtAddWorkImageLabel.isVisible = false
        }

        data.imageDetail.forEach {
            val url = Global.baseURL + it.imgPath
            val item = ItemImgItemBinding.inflate(layoutInflater)
            item.btnClose.isVisible = false

            control.layoutImgList.addView(item.root)
            Glide.with(this).load(url).into(item.img)
        }

        control.txtDate.text = data.dateTime
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.home -> {
                this.finish()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}