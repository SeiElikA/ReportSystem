package com.seielika.reportapp.Adapter

import android.content.Context
import android.content.Intent
import android.content.res.ColorStateList
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import androidx.constraintlayout.utils.widget.ImageFilterView
import androidx.core.view.isGone
import androidx.core.view.isVisible
import androidx.core.view.updateLayoutParams
import com.bumptech.glide.Glide
import com.seielika.reportapp.Data.ReportContent
import com.seielika.reportapp.Global
import com.seielika.reportapp.View.ReportDetailActivity
import com.seielika.reportapp.databinding.ItemImgBinding
import com.seielika.reportapp.databinding.ItemReportContentBinding
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class ReportAdapter(var context: Context, var list: List<ReportContent>): BaseAdapter() {
    override fun getCount(): Int {
        return list.count()
    }

    override fun getItem(position: Int): Any {
        return list[position]
    }

    override fun getItemId(position: Int): Long {
        return list[position].id.toLong()
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val control = ItemReportContentBinding.inflate(LayoutInflater.from(context), parent, false)
        val data = list.get(position)
        if(data.dateTime != LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))) {
            control.cardPoint.setStrokeColor(ColorStateList.valueOf(Color.GRAY))
            control.cardPoint.setStrokeColor(ColorStateList.valueOf(Color.GRAY))
            control.cardCorrectDate.isGone = true
        }

        if(list.count() -1 == list.indexOf(data)) {
            control.layoutLine.isVisible = false
        }

        control.txtDate.text = data.dateTime
        control.txtReportDetail.text = data.reportDetail
            .mapIndexed { index, reportDetail ->  "${index + 1}. ${reportDetail.content}"}
            .joinToString(separator = "\n")

        // add image detail
        data.imageDetail.forEach {
            val url = Global.baseURL + it.imgPath
            val img = ItemImgBinding.inflate(LayoutInflater.from(context), parent ,false)
            control.layoutImageDetail.addView(img.root)
            Glide.with(context)
                .load(url)
                .into(img.root)
        }

        control.root.setOnClickListener {
            context.startActivity(Intent(context, ReportDetailActivity::class.java).putExtra("data", data))
        }

        return control.root
    }

}