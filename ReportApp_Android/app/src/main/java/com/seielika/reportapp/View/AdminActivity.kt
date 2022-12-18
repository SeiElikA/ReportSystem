package com.seielika.reportapp.View

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import com.seielika.reportapp.View.Fragment.LowTaskFragment
import com.seielika.reportapp.databinding.ActivityAdminBinding

class AdminActivity : AppCompatActivity() {
    private lateinit var control: ActivityAdminBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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
}