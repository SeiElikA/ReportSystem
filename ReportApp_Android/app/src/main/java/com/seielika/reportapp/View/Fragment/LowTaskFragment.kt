package com.seielika.reportapp.View.Fragment

import android.app.ProgressDialog
import android.os.Bundle
import android.text.BoringLayout
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import androidx.appcompat.app.AlertDialog
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.seielika.reportapp.Adapter.AdminReportAdapter
import com.seielika.reportapp.Data.AdminReport
import com.seielika.reportapp.Data.ErrorResponse
import com.seielika.reportapp.Model.AdminModel
import com.seielika.reportapp.R
import com.seielika.reportapp.databinding.FragmentLowTaskBinding
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException
import kotlin.concurrent.thread

class LowTaskFragment : Fragment() {
    private lateinit var control: FragmentLowTaskBinding
    private lateinit var model: AdminModel
    private var accountList = listOf<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        control = FragmentLowTaskBinding.inflate(layoutInflater, container, false)
        model = AdminModel()
        return control.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        fetchData()

        control.rbManual.setOnCheckedChangeListener { buttonView, isChecked ->
            if(isChecked) {
                setMode(1)
            } else {
                setMode(0)
            }
        }

        control.btnSend.setOnClickListener {
            val progressDialog = ProgressDialog(context)
            progressDialog.setMessage("Loading...")
            progressDialog.setCancelable(false)
            progressDialog.show()

            // TODO: (FIX) send low task account, need use account id, but response only has account name
            // val accountId = accountList.firstOrNull { x-> x == } control.spAccount.text

            model.setLowTaskAccount()
        }
    }

    private fun fetchData() {
        if(context == null)
            return
        val progressDialog = ProgressDialog(context)
        progressDialog.setMessage("Loading...")
        progressDialog.setCancelable(false)
        progressDialog.show()
        val loadingProcess = mutableListOf<Boolean>()

        // 1. get detect mode
        model.getDetectMode(object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                activity?.runOnUiThread {
                    showErrorAlert(e.message.toString())
                    loadingProcess.add(false)
                    progressDialog.dismiss()
                }
            }

            override fun onResponse(call: Call, response: Response) {
                loadingProcess.add(true)

                if(response.code !in 200..299) {
                    val error = Gson().fromJson(response.body?.string(), ErrorResponse::class.java)
                    activity?.runOnUiThread {
                        progressDialog.dismiss()
                        showErrorAlert(error.error)
                    }
                    return
                }

                val detectMode = JSONObject(response.body?.string()).getInt("mode")
                activity?.runOnUiThread {
                    if(detectMode == 0) {
                        control.root.transitionToState(R.id.end, 0)
                        control.root.setTransitionDuration(500)
                        control.rbGroup.check(R.id.rbAuto)
                    } else {
                        control.root.transitionToState(R.id.start, 0)
                        control.root.setTransitionDuration(500)
                        control.rbGroup.check(R.id.rbManual)
                    }
                }
            }
        })

        // 2. get account list
        model.getAccountList(object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                activity?.runOnUiThread {
                    showErrorAlert(e.message.toString())
                    loadingProcess.add(false)
                    progressDialog.dismiss()
                }
            }

            override fun onResponse(call: Call, response: Response) {
                loadingProcess.add(true)
                activity?.let {
                    it.runOnUiThread {
                        val nameList = Gson().fromJson(response.body?.string(), Array<String>::class.java).toList()
                        this@LowTaskFragment.accountList = nameList
                        control.spAccount.setAdapter(ArrayAdapter(it, android.R.layout.simple_list_item_1, nameList))
                        control.spAccount.setText(nameList.first(), false)
                    }
                }
            }
        })

        // 3. today process
        model.getTodayTaskList(object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                activity?.runOnUiThread {
                    showErrorAlert(e.message.toString())
                    loadingProcess.add(false)
                    progressDialog.dismiss()
                }
            }

            override fun onResponse(call: Call, response: Response) {
                loadingProcess.add(true)
                activity?.let {
                    it.runOnUiThread {
                        val reportList = Gson().fromJson(response.body?.string(), Array<AdminReport>::class.java).toList()
                        control.listView.adapter = AdminReportAdapter(it, reportList)
                    }
                }
            }
        })

        thread {
            while(loadingProcess.size != 3)

            activity?.runOnUiThread {
                progressDialog.dismiss()
            }
        }
    }

    private fun setMode(modeValue: Int) {
        if(context == null)
            return
        val progressDialog = ProgressDialog(context)
        progressDialog.setMessage("Loading...")
        progressDialog.setCancelable(false)
        progressDialog.show()

        model.setMode(modeValue, object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                activity?.runOnUiThread {
                    showErrorAlert(e.message.toString())
                    progressDialog.dismiss()
                }
            }

            override fun onResponse(call: Call, response: Response) {
                if(response.code !in 200..299) {
                    val error = Gson().fromJson(response.body?.string(), ErrorResponse::class.java)
                    activity?.runOnUiThread {
                        progressDialog.dismiss()
                        showErrorAlert(error.error)
                    }
                    return
                }
                activity?.runOnUiThread {
                    progressDialog.dismiss()

                    if(modeValue == 1) {
                        control.root.transitionToStart()
                    } else {
                        control.root.transitionToEnd()
                    }
                }
            }
        })
    }

    private fun showErrorAlert(msg: String) {
        context?.let {
            val alertDialog = AlertDialog.Builder(it)
                .setTitle("Error")
                .setMessage(msg)
                .setPositiveButton("OK", null)
                .create()
            alertDialog.show()
        }
    }

    companion object {
        fun newInstance() =
            LowTaskFragment().apply {
                arguments = Bundle().apply {
                }
            }
    }
}