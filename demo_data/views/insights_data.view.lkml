view: insights_data {
 # sql_table_name: `my_insights_dataset.my_insights_table` ;;
  sql_table_name: `dmv_ccai_insights.insights_data`;;
  view_label: "Insights Data: Conversations"

  dimension: agent_id {
    type: string
    description: "The user-provided identifier for the agent who handled the conversation."
    sql: ${TABLE}.agentId ;;
  }

  dimension: agent_sentiment_magnitude {
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of the agent sentiment regardless of score."
    sql: ${TABLE}.agentSentimentMagnitude ;;
  }

  dimension: agent_sentiment_score {
    type: number
    description: "Agent sentiment score between -1.0 (negative) and 1.0 (positive)."
    sql: ${TABLE}.agentSentimentScore ;;
  }

  dimension: agent_speaking_percentage {
    type: number
    description: "Percentage of the conversation with the agent speaking."
    sql: ${TABLE}.agentSpeakingPercentage ;;
    value_format_name: percent_2
  }

  dimension: audio_file_uri {
    type: string
    description: "Location of the audio file on GCS."
    sql: ${TABLE}.audioFileUri ;;
  }

  dimension: client_sentiment_magnitude {
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of client sentiment regardless of score."
    sql: ${TABLE}.clientSentimentMagnitude ;;
  }

  dimension: client_sentiment_score {
    type: number
    description: "Client sentiment score between -1.0 (negative) and 1.0 (positive)."
    sql: ${TABLE}.clientSentimentScore ;;
  }

  dimension: client_speaking_percentage {
    type: number
    description: "Percentage of the conversation with the client speaking."
    sql: ${TABLE}.clientSpeakingPercentage ;;
    value_format_name: percent_2
  }

  dimension: conversation_name {
    type: string
    primary_key: yes
    description: "Name of the conversation resource."
    sql: ${TABLE}.conversationName ;;
  }

  dimension: day {
    hidden: yes
    type: number
    description: "Day date part of `load_timestamp_utc`."
    sql: ${TABLE}.day ;;
  }

  dimension: duration_nanos {
    hidden: yes
    type: number
    description: "Conversation duration in nanoseconds."
    sql: ${TABLE}.durationNanos;;
  }

  dimension: duration_seconds {
    hidden: yes
    type: number
    description: "Conversation duration in seconds."
    sql: CAST(${TABLE}.durationNanos/1000000000 as INT64);;
  }

  dimension: duration_minutes {
    hidden: yes
    type: number
    description: "Conversation duration in minutes."
    sql: CAST(${TABLE}.durationNanos/60000000000 as INT64);;
  }

  dimension: entities {
    hidden: yes
    sql: ${TABLE}.entities ;;
  }

  dimension: issues {
    hidden: yes
    sql: ${TABLE}.issues ;;
  }

  dimension: labels {
    hidden: yes
    sql: ${TABLE}.labels ;;
  }

  dimension_group: load {
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC at which the conversation was loaded into Insights."
    sql: TIMESTAMP_SECONDS(${TABLE}.loadTimestampUtc) ;;
  }

  dimension: month {
    hidden: yes
    type: number
    description: "Month date part of `load_timestamp_utc`."
    sql: ${TABLE}.month ;;
  }

  dimension: sentences {
    hidden: yes
    sql: ${TABLE}.sentences ;;
  }

  dimension: silence_nanos {
    type: number
    description: "Number of nanoseconds calculated to be in silence."
    sql: ${TABLE}.silenceNanos ;;
  }

  dimension: silence_seconds {
    type: number
    description: "Number of seconds calculated to be in silence."
    sql: CAST(${TABLE}.silenceNanos/1000000000 as INT64);;
  }

  dimension: silence_minutes {
    type: number
    description: "Number of minutes calculated to be in silence."
    sql: CAST(${TABLE}.silenceNanos/60000000000 as INT64) ;;
  }

  dimension: silence_percentage {
    type: number
    description: "Percentage of the total conversation spent in silence."
    sql: ${TABLE}.silencePercentage ;;
    value_format_name: percent_2
  }

  dimension_group: start {
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC at which the conversation started."
    sql: TIMESTAMP_SECONDS(${TABLE}.startTimestampUtc) ;;
  }

  dimension_group: end {
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC at which the conversation ended."
    sql: TIMESTAMP_SECONDS(${TABLE}.startTimestampUtc+${duration_seconds}) ;;
  }

  dimension_group: conversation {
    type: duration
    intervals: [second, minute, hour]
    sql_start: ${start_raw} ;;
    sql_end: ${end_raw} ;;
  }

  dimension: transcript {
    type: string
    description: "The complete text transcript of the conversation."
    sql: ${TABLE}.transcript ;;
  }

  dimension: turn_count {
    type: number
    description: "The number of turns taken in the conversation."
    sql: ${TABLE}.turnCount ;;
  }

  dimension: words {
    hidden: yes
    sql: ${TABLE}.words ;;
  }

  dimension: year {
    hidden: yes
    type: number
    description: "Year date part of `load_timestamp_utc`."
    sql: ${TABLE}.year ;;
  }

  dimension: sentiment_category {
    type: string
    sql: case when ${client_sentiment_score} <0 then "bad"
    when ${client_sentiment_score} >0 then "good"
    else "neutral" end;;
  }


### Measures ###
  measure: conversation_count {
    type: count
    drill_fields: [conversation_name]
  }

  measure: bad_sentiment_conversation_count {
    type: count
    filters: [sentiment_category: "bad"]
  }

  measure: good_sentiment_conversation_count {
    type: count
    filters: [sentiment_category: "good"]
  }

  measure: neutral_sentiment_conversation_count {
    type: count
    filters: [sentiment_category: "neutral"]
  }

  measure: average_turn_count {
    type: average
    sql: ${turn_count} ;;
    value_format_name: decimal_0
  }

  measure: average_conversation_minutes {
    type: average
    sql: ${minutes_conversation} ;;
    value_format_name: decimal_0
  }

  measure: average_silence_percentage {
    type: average
    sql: ${silence_percentage} ;;
    value_format_name: percent_2
  }

  measure: average_agent_speaking_percentage {
    type: average
    sql: ${agent_speaking_percentage} ;;
    value_format_name: percent_2
  }

  measure: average_client_speaking_percentage {
    type: average
    sql: ${client_speaking_percentage} ;;
    value_format_name: percent_2
  }

  measure: bad_sentiment_ratio {
    type: number
    sql: ${bad_sentiment_conversation_count}/${conversation_count} ;;
    value_format_name: percent_2
  }

  measure: good_sentiment_ratio {
    type: number
    sql: ${good_sentiment_conversation_count}/${conversation_count} ;;
    value_format_name: percent_2
  }

  measure: neutral_sentiment_ratio {
    type: number
    sql: ${neutral_sentiment_conversation_count}/${conversation_count} ;;
    value_format_name: percent_2
  }


}

view: insights_data__words {
  dimension: end_offset_nanos {
    type: number
    description: "Time offset in nanoseconds of the end of this word relative to the beginning of the conversation."
    sql: ${TABLE}.endOffsetNanos ;;
  }

  dimension: language_code {
    type: string
    description: "Language code."
    sql: ${TABLE}.languageCode ;;
  }

  dimension: speaker_tag {
    type: number
    description: "The speaker that the word originated from."
    sql: ${TABLE}.speakerTag ;;
  }

  dimension: start_offset_nanos {
    type: number
    description: "Time offset in nanoseconds of the start of this word relative to the beginning of the conversation."
    sql: ${TABLE}.startOffsetNanos ;;
  }

  dimension: word {
    type: string
    description: "The transcribed word."
    sql: ${TABLE}.word ;;
  }

  measure: count {
    type: count_distinct
    sql: ${word} ;;
  }
}

view: insights_data__labels {
  dimension: key {
    type: string
    description: "User-provided label key."
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    type: string
    description: "User-provided label value."
    sql: ${TABLE}.value ;;
  }
}

view: insights_data__issues {
  dimension: name {
    type: string
    description: "Name of the issue."
    sql: ${TABLE}.name ;;
  }

  dimension: score {
    type: number
    description: "Score indicating the likelihood of the issue assignment, between 0 and 1.0."
    sql: ${TABLE}.score ;;
  }

  measure: count {
    type: count_distinct
    sql: ${name} ;;
  }
}

view: insights_data__entities {
  dimension: name {
    type: string
    description: "Name of the entity."
    sql: ${TABLE}.name ;;
  }

  dimension: salience {
    type: number
    description: "Salience score of the entity."
    sql: ${TABLE}.salience ;;
  }

  dimension: sentiment_magnitude {
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of the entity sentiment regardless of score."
    sql: ${TABLE}.sentimentMagnitude ;;
  }

  dimension: sentiment_score {
    type: number
    description: "The entity sentiment score between -1.0 (negative) and 1.0 (positive)."
    sql: ${TABLE}.sentimentScore ;;
  }

  dimension: speaker_tag {
    type: number
    description: "The speaker that the entity mention originated from."
    sql: ${TABLE}.speakerTag ;;
  }

  dimension: type {
    type: string
    description: "Type of the entity."
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count_distinct
    sql: ${name} ;;
  }
}

view: insights_data__sentences {
  dimension: annotations {
    hidden: yes
    sql: ${TABLE}.annotations ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "Time in UTC that the conversation message took place, if provided."
    sql: TIMESTAMP_MICROS(CAST(${TABLE}.createTimeNanos/1000 as INT64)) ;;
  }

  dimension: dialogflow_intent_match_data {
    hidden: yes
    sql: ${TABLE}.dialogflowIntentMatchData ;;
  }

  dimension: end_offset_nanos {
    type: number
    description: "Time offset in nanoseconds of the end of this sentence relative to the beginning of the conversation."
    sql: ${TABLE}.endOffsetNanos ;;
  }

  dimension: intent_match_data {
    hidden: yes
    sql: ${TABLE}.intentMatchData ;;
  }

  dimension: is_covered_by_smart_reply_allowlist {
    type: yesno
    description: "Whether this message is covered by a configured allowlist in Agent Assist."
    sql: ${TABLE}.isCoveredBySmartReplyAllowlist ;;
  }

  dimension: language_code {
    type: string
    description: "Language code."
    sql: ${TABLE}.languageCode ;;
  }

  dimension: obfuscated_external_user_id {
    type: string
    description: "Customer provided obfuscated external user ID for billing purposes."
    sql: ${TABLE}.obfuscatedExternalUserId ;;
  }

  dimension: participant_id {
    type: string
    description: "Participant ID, if provided."
    sql: ${TABLE}.participantId ;;
  }

  dimension: participant_role {
    type: string
    description: "Participant role, if provided."
    sql: ${TABLE}.participantRole ;;
  }

  dimension: phrase_match_data {
    hidden: yes
    sql: ${TABLE}.phraseMatchData ;;
  }

  dimension: sentence {
    type: string
    description: "The transcribed sentence."
    sql: ${TABLE}.sentence ;;
  }

  dimension: sentiment_magnitude {
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of the sentence sentiment regardless of score."
    sql: ${TABLE}.sentimentMagnitude ;;
  }

  dimension: sentiment_score {
    type: number
    description: "The sentence sentiment score between -1.0 (negative) and 1.0 (positive)."
    sql: ${TABLE}.sentimentScore ;;
  }

  dimension: speaker_tag {
    type: number
    description: "The speaker that the sentence originated from."
    sql: ${TABLE}.speakerTag ;;
  }

  dimension: start_offset_nanos {
    type: number
    description: "Time offset in nanoseconds of the start of this sentence relative to the beginning of the conversation."
    sql: ${TABLE}.startOffsetNanos ;;
  }

  measure: count {
    type: count_distinct
    sql: ${sentence} ;;
  }
}

view: insights_data__sentences__annotations {
  label: "Insights Data: Sentences"
  dimension: clicked {
    type: yesno
    description: "Customer feedback on whether the suggestion was clicked."
    sql: ${TABLE}.clicked ;;
  }

  dimension: correctness_level {
    type: string
    description: "Customer feedback on the correctness level of the suggestion."
    sql: ${TABLE}.correctnessLevel ;;
  }

  dimension_group: create {
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC when the suggestion was generated."
    sql: TIMESTAMP_MICROS(CAST(${TABLE}.createTimeNanos/1000 as INT64)) ;;
  }

  dimension: displayed {
    type: yesno
    description: "Customer feedback on whether the suggestion was displayed."
    sql: ${TABLE}.displayed ;;
  }

  dimension: record {
    type: string
    description: "The suggestion content returned from CCAI, serialised as JSON."
    sql: ${TABLE}.record ;;
  }

  dimension: type {
    type: string
    description: "The type of suggestion."
    sql: ${TABLE}.type ;;
  }
}

view: insights_data__sentences__intent_match_data {
  dimension: display_name {
    type: string
    description: "The human readable name of the matched intent."
    sql: ${TABLE}.displayName ;;
  }

  dimension: intent_id {
    type: string
    description: "The unique ID of the matched intent."
    sql: ${TABLE}.intentId ;;
  }
}

view: insights_data__sentences__phrase_match_data {
  dimension: display_name {
    type: string
    description: "The human readable name of the phrase matcher."
    sql: ${TABLE}.displayName ;;
  }

  dimension: phrase_matcher_id {
    type: string
    description: "The unique ID of the phrase matcher."
    sql: ${TABLE}.phraseMatcherId ;;
  }

  dimension: revision_id {
    type: number
    description: "Indicating the revision of the phrase matcher."
    sql: ${TABLE}.revisionId ;;
  }
}

view: insights_data__sentences__dialogflow_intent_match_data {
  dimension: display_name {
    type: string
    description: "The human readable name of the matched intent."
    sql: ${TABLE}.displayName ;;
  }

  dimension: intent_match_source {
    type: string
    description: "The source of the matched intent, either ANALYZE_CONTENT or DETECT_INTENT."
    sql: ${TABLE}.intentMatchSource ;;
  }

  dimension: intent_name {
    type: string
    description: "The resource name of the matched intent."
    sql: ${TABLE}.intentName ;;
  }

  dimension: max_confidence {
    type: number
    description: "The maximum confidence seen for the intent in the current transcript chunk."
    sql: ${TABLE}.maxConfidence ;;
  }
}

view: sentence_turn_number {
  derived_table: {
    sql: SELECT
    insights_data.conversationName  AS conversation_name,
    insights_data__sentences.sentence  AS sentence,
        insights_data__sentences.createTimeNanos AS created_test,
        rank() over(partition by insights_data.conversationName order by insights_data__sentences.createTimeNanos asc) AS turn_number
    FROM `dmv_ccai_insights.insights_data` AS insights_data
    LEFT JOIN UNNEST(insights_data.sentences) as insights_data__sentences
    GROUP BY
    1,
    2,
    3 ;;
    }

  dimension: conversation_name {
    hidden: yes
    description: "Name of the conversation resource."
  }
  dimension: sentence {
    hidden: yes
    description: "The transcribed sentence."
  }
  dimension: created_test {
    hidden: yes
    type: number
  }
  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "Time in UTC that the conversation message took place, if provided."
    sql: TIMESTAMP_MICROS(CAST(${created_test}/1000 as INT64)) ;;
  }
  dimension: turn_number {
    type: number
    description: "The turn number of the sentence within the conversation."
  }
}

view: human_agent_turns {
  derived_table: {
    sql: WITH sentence_turn_number AS (SELECT
    insights_data.conversationName  AS conversation_name,
    insights_data__sentences.sentence  AS sentence,
    insights_data__sentences.createTimeNanos AS created_test,
    rank() over(partition by insights_data.conversationName order by insights_data__sentences.createTimeNanos asc) AS turn_number
    FROM `dmv_ccai_insights.insights_data` AS insights_data
    LEFT JOIN UNNEST(insights_data.sentences) as insights_data__sentences
    GROUP BY
    1,
    2,
    3 )
SELECT
    insights_data.conversationName  AS conversation_name,
    min(sentence_turn_number.turn_number) AS first_turn_human_agent
FROM `dmv_ccai_insights.insights_data` AS insights_data
LEFT JOIN UNNEST(insights_data.sentences) as insights_data__sentences
LEFT JOIN sentence_turn_number ON insights_data.conversationName=sentence_turn_number.conversation_name
    and insights_data__sentences.sentence = sentence_turn_number.sentence
    and (TIMESTAMP_MICROS(CAST(insights_data__sentences.createTimeNanos/1000 as INT64))) = (TIMESTAMP_MICROS(CAST(sentence_turn_number.created_test/1000 as INT64)))
    where insights_data__sentences.participantRole = "HUMAN_AGENT"
GROUP BY
    1 ;;
  }

  dimension: conversation_name {
    hidden: yes
    description: "Name of the conversation resource."
  }
  dimension: first_turn_human_agent {
    description: "The turn number for the first time a human agent entered a conversation."
  }
  measure: average_first_turn_human_agent {
    type: average
    sql: ${first_turn_human_agent} ;;
    value_format_name: decimal_0
  }
}
