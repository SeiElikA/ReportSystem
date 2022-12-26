package com.seielika.reportapp.View

import android.app.ProgressDialog
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.core.view.isGone
import com.google.android.material.snackbar.Snackbar
import com.google.gson.Gson
import com.seielika.reportapp.Data.ErrorResponse
import com.seielika.reportapp.Data.Report
import com.seielika.reportapp.Data.ReportSend
import com.seielika.reportapp.Model.AddReportModel
import com.seielika.reportapp.databinding.ActivityAddReportBinding
import com.seielika.reportapp.databinding.ItemImgItemBinding
import com.seielika.reportapp.databinding.ItemWorkItemBinding
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException

class AddReportActivity : AppCompatActivity() {
    private lateinit var control: ActivityAddReportBinding
    private val workItemList = mutableListOf<String>()
    private val workImgList = mutableListOf<Bitmap>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        control = ActivityAddReportBinding.inflate(layoutInflater)
        setContentView(control.root)
        title = "Report Detail"

        setListView()
        setImgListView()

        control.btnAdd.setOnClickListener {
            val input = control.txtInput.text.toString()
            if(input.isBlank()) {
                val snackbar = Snackbar.make(control.root, "Input can't empty", Snackbar.LENGTH_SHORT)
                snackbar.setBackgroundTint(Color.RED)
                snackbar.show()
                return@setOnClickListener
            }

            if(workItemList.any { x->x == input }) {
                val snackbar = Snackbar.make(control.root, "Work item is exist", Snackbar.LENGTH_SHORT)
                snackbar.setBackgroundTint(Color.RED)
                snackbar.show()
                return@setOnClickListener
            }

            control.txtInput.setText("")
            workItemList.add(input)
            setListView()
        }

        control.btnAddImg.setOnClickListener {
            activityPickerImage.launch("image/*")
        }

        control.btnSend.setOnClickListener {
            if(workItemList.isEmpty()) {
                val snackbar = Snackbar.make(control.root, "Please add a work item at least", Snackbar.LENGTH_SHORT)
                snackbar.setBackgroundTint(Color.RED)
                snackbar.show()
                return@setOnClickListener
            }

            val model = AddReportModel()

            val progressDialog = ProgressDialog(this)
            progressDialog.setMessage("Send...")
            progressDialog.setCancelable(false)
            progressDialog.show()

            val report = Report(workItemList.map { ReportSend(it) }, getSharedPreferences("User", Context.MODE_PRIVATE).getInt("id", -1))
            model.sendReport(report, object: Callback {
                override fun onFailure(call: Call, e: IOException) {
                    runOnUiThread {
                        progressDialog.dismiss()
                        showErrorAlert(e.message.toString())
                    }
                }

                override fun onResponse(call: Call, response: Response) {
                    if(response.code !in 200..299) {
                        val error = Gson().fromJson(response.body?.string(), ErrorResponse::class.java)
                        runOnUiThread {
                            progressDialog.dismiss()
                            showErrorAlert(error.error)
                        }
                        return
                    }
                    val reportId = JSONObject(response.body?.string()).getInt("reportId")

                    if(workImgList.isEmpty()) {
                        runOnUiThread {
                            MainActivity.instance?.refreshView()
                            progressDialog.dismiss()
                            Toast.makeText(this@AddReportActivity, "Send Report Successful", Toast.LENGTH_SHORT).show()
                            this@AddReportActivity.finish()
                        }
                        return
                    }

                    model.sendImage(reportId, workImgList, object: Callback {
                        override fun onFailure(call: Call, e: IOException) {
                            runOnUiThread {
                                progressDialog.dismiss()
                                showErrorAlert(e.message.toString())
                            }
                        }

                        override fun onResponse(call: Call, response: Response) {
                            runOnUiThread {
                                MainActivity.instance?.refreshView()
                                progressDialog.dismiss()
                                Toast.makeText(this@AddReportActivity, "Send Report Successful", Toast.LENGTH_SHORT).show()
                                this@AddReportActivity.finish()
                            }
                        }
                    })
                }
            })
        }
    }

    private var activityPickerImage = registerForActivityResult(ActivityResultContracts.GetContent()) {
        if(it == null) {
            return@registerForActivityResult
        }

        val inputStream = contentResolver.openInputStream(it)
        val bitmap = BitmapFactory.decodeStream(inputStream)
        workImgList.add(bitmap)
        setImgListView()
    }

    private fun setListView() {
        control.layoutWorkItem.removeAllViews()
        control.txtIsEmpty.isGone = workItemList.isNotEmpty()

        workItemList.forEachIndexed { index, s ->
            val item = ItemWorkItemBinding.inflate(layoutInflater)
            item.txtItem.text = "${index + 1}. $s"
            item.btnClose.setOnClickListener {
                workItemList.remove(s)
                setListView()
            }

            control.layoutWorkItem.addView(item.root)
        }
    }

    private fun setImgListView() {
        control.layoutImgList.removeAllViews()

        workImgList.forEachIndexed { index, s ->
            val item = ItemImgItemBinding.inflate(layoutInflater)
            item.img.setImageBitmap(s)
            item.btnClose.setOnClickListener {
                workImgList.remove(s)
                setImgListView()
            }

            control.layoutImgList.addView(item.root)
        }
    }

    private fun showErrorAlert(msg: String) {
        val alertDialog = AlertDialog.Builder(this)
            .setTitle("Error")
            .setMessage(msg)
            .setPositiveButton("OK", null)
            .create()
        alertDialog.show()
    }
}