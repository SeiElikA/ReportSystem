package com.seielika.reportapp.View

import android.R
import android.app.ProgressDialog
import android.content.Intent
import android.os.Bundle
import android.util.Patterns
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import com.seielika.reportapp.Data.ErrorResponse
import com.seielika.reportapp.Data.LoginResponse
import com.seielika.reportapp.Data.Register
import com.seielika.reportapp.Model.RegisterModel
import com.seielika.reportapp.databinding.ActivityRegisterBinding
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Response
import java.io.IOException

class RegisterActivity : AppCompatActivity() {
    private lateinit var control: ActivityRegisterBinding
    private lateinit var model: RegisterModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        control = ActivityRegisterBinding.inflate(layoutInflater)
        setContentView(control.root)
        title = "Registration"
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        model = RegisterModel()

        control.btnRegister.setOnClickListener {
            val email = control.txtEmail.text.toString()
            val password = control.txtPassword.text.toString()
            val name = control.txtName.text.toString()

            if (!isContentCorrect()) {
                return@setOnClickListener
            }

            val register = Register(name, email, password)
            // progress view
            val progressDialog = ProgressDialog(this)
            progressDialog.setMessage("Register...")
            progressDialog.setCancelable(false)
            progressDialog.show()

            model.register(register, object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    runOnUiThread {
                        progressDialog.dismiss()
                        showErrorAlert(e.message.toString())
                    }
                }

                override fun onResponse(call: Call, response: Response) {
                    runOnUiThread {
                        progressDialog.dismiss()
                        val bodyJson = response.body?.string()
                        if (response.code in 200..299) {
                            val data = Gson().fromJson(
                                bodyJson,
                                com.seielika.reportapp.Data.Response::class.java
                            )
                            if (data.success) {
                                showSuccessfulAlert()
                            }
                            return@runOnUiThread
                        }

                        val error = Gson().fromJson(bodyJson, ErrorResponse::class.java)
                        showErrorAlert(error.error)
                    }
                }
            })
        }
    }

    private fun isContentCorrect(): Boolean {
        val email = control.txtEmail.text.toString()
        val password = control.txtPassword.text.toString()
        val confirmPassword = control.txtConfirmPassword.text.toString()
        val name = control.txtName.text.toString()

        if (email.isBlank()) {
            showErrorAlert("Email can't empty")
            return false
        }

        if (!Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            showErrorAlert("Email format not correct")
            return false
        }

        if (password.isBlank()) {
            showErrorAlert("Password can't empty")
            return false
        }

        if (password.length < 8 || password.all { x -> x.isDigit() }) {
            showErrorAlert("Password is too easy")
            return false
        }

        if (password != confirmPassword) {
            showErrorAlert("Confirm password not match")
            return false
        }

        if (name.isBlank()) {
            showErrorAlert("Name can't empty")
            return false
        }

        return true
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

    private fun showErrorAlert(msg: String) {
        val alertDialog = AlertDialog.Builder(this)
            .setTitle("Error")
            .setMessage(msg)
            .setPositiveButton("OK", null)
            .create()
        alertDialog.show()
    }

    private fun showSuccessfulAlert() {
        val alertDialog = AlertDialog.Builder(this)
            .setTitle("Successful")
            .setMessage("Register Successful")
            .setPositiveButton("OK") { _, _ ->
                this.finish()
            }
            .create()
        alertDialog.show()
    }

}