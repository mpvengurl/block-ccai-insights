##################### Constants ###################

constant: CONNECTION {
  #value: "nys_dmv_prd" #NY DMV Data
  value: "demodataset" #CCAI Demo Data
  export: override_optional
}

constant: INSIGHTS_TABLE {
  #value: "dmv_ccai_insights.insights_data" #NY DMV Data
  value: "my_insights_dataset.my_insights_table" #CCAI Demo Data
  export: override_optional
}

constant: UNNEST_TABLE {
  #value: "insights_data" #NY DMV Data
  value: "my_insights_table" #CCAI Demo Data
  export: override_optional
}
