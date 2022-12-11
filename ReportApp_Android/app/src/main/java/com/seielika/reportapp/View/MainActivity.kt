package com.seielika.reportapp.View

import android.app.ProgressDialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import android.view.Menu
import android.view.MenuItem
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.core.view.isGone
import com.google.gson.Gson
import com.seielika.reportapp.Adapter.ReportAdapter
import com.seielika.reportapp.Data.ReportContent
import com.seielika.reportapp.Model.LoginModel
import com.seielika.reportapp.Model.MainModel
import com.seielika.reportapp.databinding.ActivityMainBinding
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Response
import java.io.IOException

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var model: MainModel
    private lateinit var adapter: ReportAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        title = "Report"
        model = MainModel()

        binding.root.setOnRefreshListener {
            fetchData()
        }

        fetchData()
    }

    private fun fetchData() {
        // fetch report content
        // progress view
        val progressDialog = ProgressDialog(this)
        progressDialog.setMessage("Register...")
        progressDialog.setCancelable(false)
        progressDialog.show()

        val accountId = getSharedPreferences("User", Context.MODE_PRIVATE).getInt("id", -1)
        model.fetchReportContent(accountId, object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                runOnUiThread {
                    progressDialog.dismiss()
                    binding.root.isRefreshing = false
                    showErrorAlert(e.message.toString())
                }
            }

            override fun onResponse(call: Call, response: Response) {
                runOnUiThread {
                    progressDialog.dismiss()
                    binding.root.isRefreshing = false
                    val bodyJson = response.body?.string()
                    if (response.code in 200..299) {
                        val dataList = Gson().fromJson(
                            bodyJson,
                            Array<ReportContent>::class.java
                        ).toList()

                        setListView(dataList)
                        return@runOnUiThread
                    }
                }
            }

        })
    }

    private fun setListView(list: List<ReportContent>) {
        if(list.isEmpty()) {
            return
        }

        binding.layoutPlaceHolder.isGone = true
        adapter = ReportAdapter(this, list)
        binding.listView.adapter = adapter
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menu?.add("Logout")
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if(item.title == "Logout") {
            model.clearLoginInfo(this)
            val intent = Intent(this, LoginActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            startActivity(intent)
        }
        return super.onOptionsItemSelected(item)
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