view: insights_data {
  sql_table_name: @{INSIGHTS_TABLE} ;;
  view_label: "1: Conversations"

  dimension: agent_id {
    type: string
    description: "The user-provided identifier for the human agent who handled the conversation."
    sql: ${TABLE}.agentId ;;
  }

  dimension: agent_sentiment_magnitude {
    group_label: "Sentiment"
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of the agent sentiment regardless of score."
    sql: ${TABLE}.agentSentimentMagnitude ;;
  }

  dimension: agent_sentiment_score {
    group_label: "Sentiment"
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
    group_label: "Sentiment"
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of client sentiment regardless of score."
    sql: ${TABLE}.clientSentimentMagnitude ;;
  }

  dimension: client_sentiment_score {
    group_label: "Sentiment"
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
    #link: {
    #  label: "Sentences Drill - Explore"
    #  url: "https://nydmvtest.cloud.looker.com/explore/insights_demo/insights_data?qid=LkNbSc9soYLmQo39wf47Bk&toggle=fil,vis#drillmenu&fields=sentence_turn_number.turn_number,
    #  %20insights_data__sentences.sentence,%20insights_data__sentences.participant_role&f[insights_data.conversation_name]={{ value }}&limit=1000&sorts=sentence_turn_number.turn_number+asc"
    #  }
    link: {
      label: "Conversation Lookup Dashboard"
      url: "https://nydmvtest.cloud.looker.com/dashboards-next/4?Conversation+Name={{ value}}"
    }
  }

  dimension: day {
    group_label: "Dates"
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

  dimension: labels {
    hidden: yes
    sql: ${TABLE}.labels ;;
  }

  dimension_group: load {
    group_label: "Dates"
    label: "Import"
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC at which the conversation was loaded into Insights."
    sql: TIMESTAMP_SECONDS(${TABLE}.loadTimestampUtc) ;;
  }

  dimension: month {
    group_label: "Dates"
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
    hidden: yes
    type: number
    description: "Number of nanoseconds calculated to be in silence."
    sql: ${TABLE}.silenceNanos ;;
  }

  dimension: silence_seconds {
    hidden: yes
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
    group_label: "Dates"
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC at which the conversation started."
    sql: TIMESTAMP_SECONDS(${TABLE}.startTimestampUtc) ;;
  }

  dimension_group: end {
    group_label: "Dates"
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC at which the conversation ended."
    sql: TIMESTAMP_SECONDS(${TABLE}.startTimestampUtc+${duration_seconds}) ;;
  }

  dimension_group: conversation {
    description: "The time between conversation start and end."
    type: duration
    intervals: [second, minute, hour]
    sql_start: ${start_raw} ;;
    sql_end: ${end_raw} ;;
  }

  dimension: topics {
    hidden: yes
    sql: ${TABLE}.issues ;;
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

  dimension: type {
    description: "If the call was never transferred to a human, then the call is classified as Virtual. If the call was transferred to a human, then the call is classified as human."
    type: string
    sql: case when ${human_agent_turns.first_turn_human_agent} is null then "Virtual Agent"
      else "Human Agent" end;;
  }

  dimension: words {
    hidden: yes
    sql: ${TABLE}.words ;;
  }

  dimension: year {
    group_label: "Dates"
    hidden: yes
    type: number
    description: "Year date part of `load_timestamp_utc`."
    sql: ${TABLE}.year ;;
  }

  dimension: client_sentiment_category {
    group_label: "Sentiment"
    type: string
    description: "Negative sentiment score is bad, 0 sentiment score is neutral, and positive sentiment score is good."
    sql: CASE
    WHEN ${client_sentiment_score} <= -0.1 AND ${client_sentiment_magnitude} > 0.1  THEN "Negative"
    WHEN ${client_sentiment_score} >= 0.1 AND ${client_sentiment_magnitude} > 0.1 THEN "Positive"
    WHEN (${client_sentiment_score} < 0.1 OR ${client_sentiment_score} > -0.1) AND ${client_sentiment_magnitude} > 0.1 THEN "Mixed"
    ELSE "Neutral" END;;
  }

  dimension: agent_sentiment_category {
    group_label: "Sentiment"
    type: string
    description: "Negative sentiment score is bad, 0 sentiment score is neutral, and positive sentiment score is good."
    sql: CASE
    WHEN ${agent_sentiment_score} <= -0.1 AND ${agent_sentiment_magnitude} > 0.25  THEN "Negative"
    WHEN ${agent_sentiment_score} >= 0.1 AND ${agent_sentiment_magnitude} > 0.25 THEN "Positive"
    WHEN (${agent_sentiment_score} < 0.1 OR ${agent_sentiment_score} > -0.1) AND ${agent_sentiment_magnitude} > 0.25 THEN "Mixed"
    ELSE "Neutral" END;;
  }


  ###################### Period over Period Reporting Metrics ######################

  parameter: period {
    hidden: yes
    label: "Timeframe"
    view_label: "Period over Period"
    description: "Use with Period Over Period Date to choose the timeframe for analysis (WTD, MTD, QTD, YTD)"
    type: unquoted
    allowed_value: {
      label: "Week to Date"
      value: "Week"
    }
    allowed_value: {
      label: "Month to Date"
      value: "Month"
    }
    allowed_value: {
      label: "Quarter to Date"
      value: "Quarter"
    }
    allowed_value: {
      label: "Year to Date"
      value: "Year"
    }
    default_value: "Week"
    required_fields: [pop_date,period_selected]
  }

  parameter: pop_date {
    hidden: yes
    label: "Period Over Period Date"
    view_label: "Period over Period"
    description: "Choose your start date for period over period analysis. Uses Conversation Import Date."
    type: date
    suggest_dimension: load_date
    required_fields: [period, period_selected]
  }

  # To get start date we need to get either first day of the year, month or quarter
  dimension: first_date_in_period {
    hidden: yes
    view_label: "Period over Period"
    datatype: date
    type: date
    sql: DATE_TRUNC(date({% parameter pop_date %}), {% parameter period %});;
  }

  #Now get the total number of days in the period
  dimension: days_in_period {
    hidden: yes
    view_label: "Period over Period"
    type: number
    sql: DATE_DIFF(date({% parameter pop_date %}),${first_date_in_period}, DAY) ;;
  }


  #Now get the first date in the prior period
  dimension: first_date_in_prior_period {
    view_label: "Period over Period"
    datatype: date
    type: date
    hidden: yes
    sql: DATE_TRUNC(DATE_ADD(date({% parameter pop_date %}), INTERVAL -1 {% parameter period %}),{% parameter period %});;
  }

  #Now get the last date in the prior period
  dimension: last_date_in_prior_period {
    hidden: yes
    datatype: date
    view_label: "Period over Period"
    type: date
    sql: DATE_ADD(date(${first_date_in_prior_period}), INTERVAL ${days_in_period} DAY) ;;
  }

  # Now figure out which period each date belongs in
  dimension: period_selected {
    hidden: yes
    label: "Period Over Period"
    view_label: "Period over Period"
    type: string
    required_fields: [period,pop_date]
    sql:
        CASE
          WHEN date(${load_raw}) >=  date(${first_date_in_period})
          AND date(${load_raw}) <=  date({% parameter pop_date %})
          THEN 'Selected {% parameter period %} to Date'
          WHEN date(${load_raw}) >= date(${first_date_in_prior_period})
          AND date(${load_raw}) <= date(${last_date_in_prior_period})
          THEN 'Prior {% parameter period %} to Date'
          ELSE NULL
          END ;;
  }


  dimension: days_from_period_start {
    hidden: yes
    view_label: "Period over Period"
    type: number
    sql: CASE WHEN ${period_selected} = 'Selected {% parameter period %} to Date'
          THEN DATE_DIFF(${load_date}, ${first_date_in_period}, DAY)
          WHEN ${period_selected} = 'Prior {% parameter period %} to Date'
          THEN DATE_DIFF(${load_date}, ${first_date_in_prior_period}, DAY)
          ELSE NULL END;;
  }


### Measures ###
  measure: conversation_count {
    type: count
    drill_fields: [convo_info*]
  }

#NYDMV
  measure: contained_count {
    description: "A conversation is considered contained if it was never passed to a human agent."
    type: count
    filters: [type: "Virtual Agent"]
    drill_fields: [convo_info*]
  }

#NYDMV
  measure: contained_percentage {
    description: "A conversation is considered contained if it was never passed to a human agent."
    type: number
    sql: ${contained_count}/${conversation_count} ;;
    value_format_name: percent_0
    drill_fields: [convo_info*]
  }

#NYDMV
  measure: bad_sentiment_conversation_count {
    group_label: "Sentiment"
    description: "Based on client sentiment score"
    type: count
    filters: [client_sentiment_category: "bad"]
    drill_fields: [convo_info*]
  }

#NYDMV
  measure: good_sentiment_conversation_count {
    group_label: "Sentiment"
    description: "Based on client sentiment score"
    type: count
    filters: [client_sentiment_category: "good"]
    drill_fields: [convo_info*]
  }

#NYDMV
  measure: neutral_sentiment_conversation_count {
    group_label: "Sentiment"
    description: "Based on client sentiment score"
    type: count
    filters: [client_sentiment_category: "neutral"]
    drill_fields: [convo_info*]
  }

  measure: num_of_characters {
    label: "Number of Characters in Conversation"
    type: sum
    sql: length(${transcript}) ;;
  }

  measure: average_turn_count {
    type: average
    sql: ${turn_count} ;;
    value_format_name: decimal_0
    drill_fields: [convo_info*, turn_count]
  }

  measure: average_conversation_minutes {
    type: average
    sql: ${minutes_conversation} ;;
    value_format_name: decimal_0
    drill_fields: [convo_info*, duration_minutes]
  }

  measure: average_silence_percentage {
    type: average
    sql: ${silence_percentage} ;;
    value_format_name: percent_2
    drill_fields: [convo_info*, silence_percentage, silence_minutes]
  }

  measure: average_agent_speaking_percentage {
    type: average
    sql: ${agent_speaking_percentage} ;;
    value_format_name: percent_2
    drill_fields: [convo_info*, agent_speaking_percentage]
  }

  measure: average_client_speaking_percentage {
    type: average
    sql: ${client_speaking_percentage} ;;
    value_format_name: percent_2
    drill_fields: [convo_info*, client_speaking_percentage]
  }

  #NYDMV
  measure: bad_sentiment_ratio {
    group_label: "Sentiment"
    type: number
    sql: ${bad_sentiment_conversation_count}/${conversation_count} ;;
    value_format_name: percent_0
    drill_fields: [convo_info*]
  }

  #NYDMV
  measure: good_sentiment_ratio {
    group_label: "Sentiment"
    type: number
    sql: ${good_sentiment_conversation_count}/${conversation_count} ;;
    value_format_name: percent_2
    drill_fields: [convo_info*]
  }

  #NYDMV
  measure: neutral_sentiment_ratio {
    group_label: "Sentiment"
    type: number
    sql: ${neutral_sentiment_conversation_count}/${conversation_count} ;;
    value_format_name: percent_2
    drill_fields: [convo_info*]
  }

  measure: average_client_sentiment_score {
    group_label: "Sentiment"
    type: average
    sql: ${client_sentiment_score} ;;
    value_format_name: decimal_2
    drill_fields: [convo_info*,client_sentiment_score]
  }

  measure: average_agent_sentiment_score {
    group_label: "Sentiment"
    type: average
    sql: ${agent_sentiment_score} ;;
    value_format_name: decimal_2
    drill_fields: [convo_info*,agent_sentiment_score]
  }

 set: convo_info {
   fields: [conversation_name, load_time, type, client_sentiment_category]
 }
}

view: insights_data__words {
  dimension: end_offset_nanos {
    hidden: yes
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
    hidden: yes
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

  measure: num_of_characters_words {
    label: "Number of Characters in Word"
    type: sum
    sql: length(${word}) ;;
  }
}

view: insights_data__labels {
  dimension: key {
    label: "Label Key"
    group_label: "Labels"
    type: string
    description: "User-provided label key."
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    label: "Label Value"
    group_label: "Labels"
    type: string
    description: "User-provided label value."
    sql: ${TABLE}.value ;;
  }
}

view: insights_data__topics {
  dimension: name {
    label: "Topic Name"
    group_label: "Topics"
    type: string
    description: "Name of the topic."
    sql: ${TABLE}.name ;;
  }

  dimension: score {
    label: "Topic Score"
    group_label: "Topics"
    type: number
    description: "Score indicating the likelihood of the topic assignment, between 0 and 1.0."
    sql: ${TABLE}.score ;;
  }

  measure: count {
    label: "Topic Count"
    group_label: "Topics"
    type: count_distinct
    sql: ${name} ;;
    drill_fields: [topic_detail*]
  }

  set: topic_detail {
    fields:[name, score]
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
    group_label: "Sentiment"
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of the entity sentiment regardless of score."
    sql: ${TABLE}.sentimentMagnitude ;;
  }

  dimension: sentiment_score {
    group_label: "Sentiment"
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
    drill_fields: [entity_detail*]
  }

  set: entity_detail {
    fields: [name,type,speaker_tag,sentiment_score, sentiment_magnitude,salience]
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
    hidden: yes
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
    group_label: "Sentiment"
    type: number
    description: "A non-negative number from zero to infinity that represents the abolute magnitude of the sentence sentiment regardless of score."
    sql: ${TABLE}.sentimentMagnitude ;;
  }

  dimension: sentiment_score {
    group_label: "Sentiment"
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
    hidden: yes
    type: number
    description: "Time offset in nanoseconds of the start of this sentence relative to the beginning of the conversation."
    sql: ${TABLE}.startOffsetNanos ;;
  }

  measure: count {
    type: count_distinct
    sql: ${sentence} ;;
  }

  measure: num_of_characters_sentences {
    label: "Number of Characters in Sentence"
    type: sum
    sql: length(${sentence}) ;;
  }
}

view: insights_data__sentences__annotations {
  label: "Insights Data: Sentences"

  dimension: clicked {
    group_label: "Annotations"
    type: yesno
    description: "Customer feedback on whether the suggestion was clicked."
    sql: ${TABLE}.clicked ;;
  }

  dimension: correctness_level {
    group_label: "Annotations"
    type: string
    description: "Customer feedback on the correctness level of the suggestion."
    sql: ${TABLE}.correctnessLevel ;;
  }

  dimension_group: create {
    group_label: "Annotations"
    type: time
    timeframes: [time, hour_of_day, date, day_of_week, week, month_name, year, raw]
    description: "The time in UTC when the suggestion was generated."
    sql: TIMESTAMP_MICROS(CAST(${TABLE}.createTimeNanos/1000 as INT64)) ;;
  }

  dimension: displayed {
    group_label: "Annotations"
    type: yesno
    description: "Customer feedback on whether the suggestion was displayed."
    sql: ${TABLE}.displayed ;;
  }

  dimension: record {
    group_label: "Annotations"
    type: string
    description: "The suggestion content returned from CCAI, serialised as JSON."
    sql: ${TABLE}.record ;;
  }

  dimension: type {
    group_label: "Annotations"
    type: string
    description: "The type of suggestion."
    sql: ${TABLE}.type ;;
  }
}

view: insights_data__sentences__intent_match_data {
  dimension: display_name {
    group_label: "Intent Match"
    label: "Intent Match Display Name"
    type: string
    description: "The human readable name of the matched intent."
    sql: ${TABLE}.displayName ;;
  }

  dimension: intent_id {
    group_label: "Intent Match"
    label: "Intent Match Intent ID"
    type: string
    description: "The unique ID of the matched intent."
    sql: ${TABLE}.intentId ;;
  }
}

view: insights_data__sentences__phrase_match_data {
  dimension: display_name {
    label: "Phrase Match Display Name"
    group_label: "Phrase Match"
    type: string
    description: "The human readable name of the phrase matcher."
    sql: ${TABLE}.displayName ;;
  }

  dimension: phrase_matcher_id {
    group_label: "Phrase Match"
    type: string
    description: "The unique ID of the phrase matcher."
    sql: ${TABLE}.phraseMatcherId ;;
  }

  dimension: revision_id {
    group_label: "Phrase Match"
    label: "Phrase Match Revision ID"
    type: number
    description: "Indicating the revision of the phrase matcher."
    sql: ${TABLE}.revisionId ;;
  }
}

view: insights_data__sentences__dialogflow_intent_match_data {
  dimension: display_name {
    group_label: "Dialogflow Intent Match (DIM)"
    label: "DIM Display Name"
    type: string
    description: "The human readable name of the matched intent."
    sql: ${TABLE}.displayName ;;
  }

  dimension: intent_match_source {
    group_label: "Dialogflow Intent Match (DIM)"
    label: "DIM Source"
    type: string
    description: "The source of the matched intent, either ANALYZE_CONTENT or DETECT_INTENT."
    sql: ${TABLE}.intentMatchSource ;;
  }

  dimension: intent_name {
    group_label: "Dialogflow Intent Match (DIM)"
    label: "DIM Intent Name"
    type: string
    description: "The resource name of the matched intent."
    sql: ${TABLE}.intentName ;;
  }

  dimension: max_confidence {
    group_label: "Dialogflow Intent Match (DIM)"
    label: "DIM Max Confidence"
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
    FROM @{INSIGHTS_TABLE} AS insights_data
    LEFT JOIN UNNEST(@{UNNEST_TABLE}.sentences) as insights_data__sentences
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
    FROM @{INSIGHTS_TABLE} AS insights_data
    LEFT JOIN UNNEST(@{UNNEST_TABLE}.sentences) as insights_data__sentences
    GROUP BY
    1,
    2,
    3 )
SELECT
    insights_data.conversationName  AS conversation_name,
    min(sentence_turn_number.turn_number) AS first_turn_human_agent
FROM @{INSIGHTS_TABLE} AS insights_data
LEFT JOIN UNNEST(@{UNNEST_TABLE}.sentences) as insights_data__sentences
LEFT JOIN sentence_turn_number ON insights_data.conversationName=sentence_turn_number.conversation_name
    and insights_data__sentences.sentence = sentence_turn_number.sentence
    and (TIMESTAMP_MICROS(CAST(insights_data__sentences.createTimeNanos/1000 as INT64))) = (TIMESTAMP_MICROS(CAST(sentence_turn_number.created_test/1000 as INT64)))
    where insights_data__sentences.participantRole = "HUMAN_AGENT"
GROUP BY
    1 ;;
  }

  dimension: conversation_name {
    hidden: yes
    primary_key:  yes
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

view: daily_facts {

  derived_table: {
    explore_source: insights_data {
      column: load_date {}
      column: conversation_count {}
      column: contained_count {}
      column: good_sentiment_conversation_count {}
      column: bad_sentiment_conversation_count {}
      column: neutral_sentiment_conversation_count {}
      column: entity_count { field: insights_data__entities.count }
      column: topic_count { field: insights_data__topics.count }
      column: contained_percentage {}
    }
  }
  dimension: load_date {
    hidden: yes
    type: date
  }
  dimension: conversation_count {
    hidden: yes
    label: "Insights Data: Conversations Conversation Count"
    type: number
  }
  measure: average_daily_conversations {
    group_label: "Daily Metrics"
    description: "Average Conversations Per Day"
    type: average
    sql: ${conversation_count} ;;
  }
  dimension: contained_count {
    hidden: yes
    label: "Insights Data: Conversations Contained Count"
    description: "A conversation is considered contained if it was never passed to a human agent."
    type: number
  }
  measure: average_daily_contained_conversations {
    group_label: "Daily Metrics"
    description: "Average Contained Conversations Per Day"
    type: average
    sql: ${contained_count} ;;
  }
  dimension: good_sentiment_conversation_count {
    hidden:  yes
    label: "Insights Data: Conversations Good Sentiment Conversation Count"
    type: number
  }
  measure: average_daily_good_sentiment_conversations {
    group_label: "Daily Metrics"
    description: "Average Good Sentiment Conversations Per Day"
    type: average
    sql: ${good_sentiment_conversation_count} ;;
  }
  dimension: bad_sentiment_conversation_count {
    hidden:  yes
    label: "Insights Data: Conversations Bad Sentiment Conversation Count"
    type: number
  }
  measure: average_daily_bad_sentiment_conversations {
    group_label: "Daily Metrics"
    description: "Average Bad Sentiment Conversations Per Day"
    type: average
    sql: ${bad_sentiment_conversation_count} ;;
  }
  dimension: neutral_sentiment_conversation_count {
    group_label: "Daily Metrics"
    hidden: yes
    label: "Insights Data: Conversations Neutral Sentiment Conversation Count"
    type: number
  }
  measure: average_daily_neutral_conversations {
    group_label: "Daily Metrics"
    description: "Average Neutral Sentiment Conversations Per Day"
    type: average
    sql: ${neutral_sentiment_conversation_count} ;;
  }
  dimension: entity_count {
    hidden:  yes
    label: "Insights Data: Entities Count"
    type: number
  }
  measure: average_daily_entities {
    group_label: "Daily Metrics"
    description: "Average Entities Per Day"
    type: average
    sql: ${entity_count} ;;
  }
  dimension: topic_count {
    hidden: yes
    type: number
  }
  measure: average_daily_topics {
    group_label: "Daily Metrics"
    description: "Average Topics Per Day"
    type: average
    sql: ${topic_count} ;;
  }
  dimension: contained_percentage {
    hidden: yes
    type: number
  }
  measure: average_daily_contained_percentage {
    group_label: "Daily Metrics"
    description: "Average Daily Contained Percentage Per Day"
    type: average
    sql: ${contained_percentage} ;;
  }
}
