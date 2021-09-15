include: "/views/insights_data.view"

view: +insights_data {
  #Configure manual score and magnitude thresholds here in the default_value field, or within the UI.
  parameter: client_sentiment_score_threshold {
    description: "Score of the sentiment ranges between -1.0 (negative) and 1.0 (positive) and corresponds to the overall emotional leaning of the text. Set a custom minimum threshold to trigger Positive and Negative. E.g., choosing 0.05 will set Score > 0.05 to Positive, and Score < -0.05 to be Negative, while also incorporating the Magnitude selection."
    hidden:  yes #Set no if you want this exposed in the Browse/Explore
    type: number
    default_value: "0.05"
  }
  parameter: client_sentiment_magnitude_threshold {
    description: "Magnitude indicates the overall strength of emotion (both positive and negative) within the given text, between 0.0 and +inf. Unlike score, magnitude is not normalized; each expression of emotion within the text (both positive and negative) contributes to the text's magnitude (so longer text blocks may have greater magnitudes). Set a custom minimum threshold to trigger Positive, Negative, and Mixed vs. Neutral. E.g., choosing 0.1 will allow Positive scores to be considered Positive (vs. Mixed) if Magnitude exceeds 0.1."
    hidden:  yes #Set no if you want this exposed in the Browse/Explore
    type:  number
    default_value: "0.1"
  }

  dimension: client_sentiment_category {
    group_label: "Sentiment"
    type: string
    description: "Negative sentiment score is bad, 0 sentiment score is neutral, and positive sentiment score is good."
    sql: CASE
          WHEN ${client_sentiment_score} <= -{% parameter client_sentiment_score_threshold %} AND ${client_sentiment_magnitude} > {% parameter client_sentiment_magnitude_threshold %}  THEN "Negative"
          WHEN ${client_sentiment_score} >= {% parameter client_sentiment_score_threshold %} AND ${client_sentiment_magnitude} > {% parameter client_sentiment_magnitude_threshold %} THEN "Positive"
          WHEN (${client_sentiment_score} < {% parameter client_sentiment_score_threshold %} OR ${client_sentiment_score} > -{% parameter client_sentiment_score_threshold %}) AND ${client_sentiment_magnitude} > {% parameter client_sentiment_magnitude_threshold %} THEN "Mixed"
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

}
