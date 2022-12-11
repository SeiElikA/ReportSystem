package com.seielika.reportapp.View

import android.app.ProgressDialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Patterns
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import com.google.android.material.appbar.CollapsingToolbarLayout
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import com.seielika.reportapp.Data.ErrorResponse
import com.seielika.reportapp.Data.LoginResponse
import com.seielika.reportapp.Model.LoginModel
import com.seielika.reportapp.databinding.ActivityLoginBinding
import com.seielika.reportapp.databinding.ActivityRegisterBinding
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Response
import java.io.IOException

class LoginActivity : AppCompatActivity() {
    private lateinit var control: ActivityLoginBinding

    private lateinit var model: LoginModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        control = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(control.root)

        title = "Login"
        model = LoginModel()
        if(getSharedPreferences("User", Context.MODE_PRIVATE).getBoolean("isLogin", false)) {
            startActivity(Intent(this, MainActivity::class.java))
            this.finish()
        }

        control.btnLogin.setOnClickListener {
            val email = control.txtEmail.text.toString()
            val password = control.txtPassword.text.toString()
            if(email.isBlank() || password.isBlank()) {
                showErrorAlert("Email or password can't empty")
                return@setOnClickListener
            }

            if(!Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
                showErrorAlert("Email format not confirm")
                return@setOnClickListener
            }

            // progress view
            val progressDialog = ProgressDialog(this)
            progressDialog.setMessage("Login...")
            progressDialog.setCancelable(false)
            progressDialog.show()

            model.login(email, password, object: Callback {
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
                        if(response.code in 200..299) {
                            val data = Gson().fromJson(bodyJson, LoginResponse::class.java)
                            model.saveLoginInfo(this@LoginActivity, data)

                            // go to main activity
                            Toast.makeText(this@LoginActivity, "Login Successful", Toast.LENGTH_SHORT).show()
                            startActivity(Intent(this@LoginActivity, MainActivity::class.java))
                            this@LoginActivity.finish()
                            return@runOnUiThread
                        }

                        val error = Gson().fromJson(bodyJson, ErrorResponse::class.java)
                        showErrorAlert(error.error)
                    }
                }
            })
        }

        control.btnRegister.setOnClickListener {
            startActivity(Intent(this, RegisterActivity::class.java))
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