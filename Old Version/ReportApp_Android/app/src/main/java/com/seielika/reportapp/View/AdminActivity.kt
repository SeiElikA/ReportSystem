package com.seielika.reportapp.View

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import com.seielika.reportapp.Model.MainModel
import com.seielika.reportapp.View.Fragment.LowTaskFragment
import com.seielika.reportapp.databinding.ActivityAdminBinding

class AdminActivity : AppCompatActivity() {
    private lateinit var model: MainModel
    private lateinit var control: ActivityAdminBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        model = MainModel()
        control = ActivityAdminBinding.inflate(layoutInflater)
        setContentView(control.root)
        title = "Admin Dashboard"
        setViewPager()
    }

    private fun setViewPager() {
        var fgList = listOf<Fragment>(
            LowTaskFragment.newInstance()
        )

        control.viewPager.adapter = object: FragmentStateAdapter(this) {
            override fun getItemCount(): Int {
                return fgList.size
            }

            override fun createFragment(position: Int): Fragment {
                return fgList[position]
            }

        }

        TabLayoutMediator(control.tabLayout, control.viewPager) { view, position ->
            if(position == 0) {
                view.text = "進度最低"
            }
        }.attach()
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
}