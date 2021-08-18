#connection: "demodataset"
connection: "nys_dmv_prd"

# include all the views
include: "/demo_data/views/**/*.view"

datagroup: insights_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: insights_default_datagroup

explore: insights_data {
  label: "Insights Demo"
  join: insights_data__words {
    view_label: "Insights Data: Words"
    sql: LEFT JOIN UNNEST(${insights_data.words}) as insights_data__words ;;
    relationship: one_to_many
  }

  join: insights_data__labels {
    view_label: "Insights Data: Labels"
    sql: LEFT JOIN UNNEST(${insights_data.labels}) as insights_data__labels ;;
    relationship: one_to_many
  }

  join: insights_data__issues {
    view_label: "Insights Data: Issues"
    sql: LEFT JOIN UNNEST(${insights_data.issues}) as insights_data__issues ;;
    relationship: one_to_many
  }

  join: insights_data__entities {
    view_label: "Insights Data: Entities"
    sql: LEFT JOIN UNNEST(${insights_data.entities}) as insights_data__entities ;;
    relationship: one_to_many
  }

  join: insights_data__sentences {
    view_label: "Insights Data: Sentences"
    sql: LEFT JOIN UNNEST(${insights_data.sentences}) as insights_data__sentences ;;
    relationship: one_to_many
  }

  join: insights_data__sentences__annotations {
    view_label: "Insights Data: Sentences Annotations"
    sql: LEFT JOIN UNNEST(${insights_data__sentences.annotations}) as insights_data__sentences__annotations ;;
    relationship: one_to_many
  }

  join: insights_data__sentences__intent_match_data {
    view_label: "Insights Data: Sentences Intentmatchdata"
    sql: LEFT JOIN UNNEST(${insights_data__sentences.intent_match_data}) as insights_data__sentences__intent_match_data ;;
    relationship: one_to_many
  }

  join: insights_data__sentences__phrase_match_data {
    view_label: "Insights Data: Sentences Phrasematchdata"
    sql: LEFT JOIN UNNEST(${insights_data__sentences.phrase_match_data}) as insights_data__sentences__phrase_match_data ;;
    relationship: one_to_many
  }

  join: insights_data__sentences__dialogflow_intent_match_data {
    view_label: "Insights Data: Sentences Dialogflowintentmatchdata"
    sql: LEFT JOIN UNNEST(${insights_data__sentences.dialogflow_intent_match_data}) as insights_data__sentences__dialogflow_intent_match_data ;;
    relationship: one_to_many
  }

  join: sentence_turn_number {
    view_label: "Insights Data: Sentences"
    relationship: one_to_many
    sql_on: ${insights_data.conversation_name}=${sentence_turn_number.conversation_name}
    and ${insights_data__sentences.sentence} = ${sentence_turn_number.sentence}
    and ${insights_data__sentences.created_raw} = ${sentence_turn_number.created_raw};;
  }

  join: human_agent_turns {
    view_label: "Insights Data: Conversations"
    relationship: one_to_one
    sql_on: ${insights_data.conversation_name} = ${human_agent_turns.conversation_name} ;;
  }
}
