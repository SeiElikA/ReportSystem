package com.seielika.reportapp.View.Fragment

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.seielika.reportapp.R
import com.seielika.reportapp.databinding.FragmentLowTaskBinding

class LowTaskFragment : Fragment() {
    private lateinit var control: FragmentLowTaskBinding
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

        return control.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        control.root.transitionToState(R.id.end, 0)
        control.root.setTransitionDuration(500)


        control.rbManual.setOnCheckedChangeListener { buttonView, isChecked ->
            if(isChecked) {
                control.root.transitionToStart()
            } else {
                control.root.transitionToEnd()
            }
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