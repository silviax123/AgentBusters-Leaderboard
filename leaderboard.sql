-- FAB++ Leaderboard Query
-- Extracts participant scores from results JSON files
-- Required: 'id' column must be first (AgentBeats agent UUID)

WITH parsed AS (
    SELECT
        json_keys(participants)[1] AS participant_id,
        participants->json_keys(participants)[1] AS participant_data,
        timestamp,
        green_agent->>'benchmark' AS benchmark
    FROM read_json_auto('results/*.json')
    WHERE participants IS NOT NULL
)
SELECT
    participant_id AS id,
    participant_data->>'name' AS "Agent",
    ROUND(CAST(participant_data->>'score' AS DOUBLE) * 100, 2) AS "Score (%)",
    ROUND(CAST(participant_data->>'accuracy' AS DOUBLE) * 100, 2) AS "Accuracy (%)",
    CAST(participant_data->>'tasks_evaluated' AS INTEGER) AS "Tasks",
    CAST(participant_data->>'tasks_successful' AS INTEGER) AS "Passed",
    ROUND(CAST(participant_data->'dataset_scores'->'bizfinbench'->>'mean_score' AS DOUBLE) * 100, 2) AS "BizFinBench (%)",
    ROUND(CAST(participant_data->'dataset_scores'->'public_csv'->>'mean_score' AS DOUBLE) * 100, 2) AS "CSV (%)",
    ROUND(CAST(participant_data->'dataset_scores'->'options'->>'mean_score' AS DOUBLE) * 100, 2) AS "Options (%)",
    timestamp AS "Last Run"
FROM parsed
ORDER BY CAST(participant_data->>'score' AS DOUBLE) DESC, timestamp DESC;
