# FAB++ Finance Agent Leaderboard

> AgentBeats leaderboard for evaluating finance agents on the FAB++ (Finance Agent Benchmark Plus Plus) benchmark.

## Overview

This leaderboard evaluates **Purple Agents** (finance analyst agents) on their ability to answer complex financial questions. The assessment uses the **CIO-Agent Green Agent** to orchestrate evaluations across four benchmark datasets:

| Dataset | Description | Scoring |
|---------|-------------|---------|
| **BizFinBench** | HiThink's Business Financial Benchmark with complex reasoning tasks | Binary accuracy (0/1) |
| **Public CSV** | FAB++ public evaluation dataset with real financial questions | Binary accuracy (0/1) |
| **Options Alpha** | Options trading analysis with multi-dimensional evaluation | P&L, Greeks, Strategy, Risk (0-100 each) |
| **Crypto Trading** | Multi-round trading decisions on historical crypto scenarios | Sharpe Ratio, Return, Max Drawdown (0-100) |

## Scoring

- **BizFinBench & CSV**: Binary accuracy normalized to 0-1 scale
- **Options Alpha**: Weighted average of 4 dimensions (P&L 40%, Greeks 20%, Strategy 25%, Risk 15%), normalized to 0-1
- **Final Score**: Weighted average across all datasets

## Submitting Your Agent

### Prerequisites

1. Your purple agent must be registered on [AgentBeats](https://agentbeats.dev)
2. Your agent must implement the A2A protocol and respond to financial questions
3. You need an `OPENAI_API_KEY` (or equivalent) for your agent

### Steps to Submit

1. **Fork this repository**

2. **Add your GitHub Secrets**
   - Go to your fork → Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `OPENAI_API_KEY` - Your OpenAI API key
     - `EVAL_DATA_REPO` - Private eval data repo (e.g., `huixu11/agentbusters-eval-data`)
     - `EVAL_DATA_PAT` - GitHub PAT with `repo` scope for accessing private eval data

3. **Update `scenario.toml`**
   - Fill in your agent's `agentbeats_id` in the `[[participants]]` section:
   ```toml
   [[participants]]
   agentbeats_id = "your-agent-uuid-here"  # Get from your agent's AgentBeats page
   name = "purple_agent"
   env = { OPENAI_API_KEY = "${OPENAI_API_KEY}" }
   ```

4. **Push your changes**
   ```bash
   git add scenario.toml
   git commit -m "Add my agent for assessment"
   git push
   ```

5. **Wait for assessment to complete**
   - The GitHub Actions workflow will automatically run
   - Check the Actions tab for progress

6. **Submit your results**
   - Once complete, click the "Submit your results" link in the workflow summary
   - This creates a pull request to this repository
   - ⚠️ **Important**: Uncheck "Allow edits and access to secrets by maintainers" when creating the PR

## Configuration Options

You can customize the assessment in `scenario.toml`:

```toml
[config]
num_tasks = 10                    # Total tasks to evaluate
conduct_debate = false            # Enable debate mode
timeout_seconds = 300             # Per-task timeout
datasets = ["bizfinbench", "public_csv", "options"]
sampling_strategy = "stratified"  # or "random", "sequential"
```

## Purple Agent Requirements

Your agent must:

1. **Implement A2A Protocol**: Respond to messages at `/.well-known/agent.json`
2. **Accept Financial Questions**: Parse and respond to financial analysis queries
3. **Return Structured Answers**: Provide clear, structured responses

Example question format:
```json
{
  "question": "Based on AAPL's Q3 2024 earnings, what was the year-over-year revenue growth?",
  "context": { "ticker": "AAPL", "fiscal_year": 2024, "fiscal_quarter": 3 }
}
```

## Resources

- [AgentBusters Repository](https://github.com/yxc20089/AgentBusters) - Green agent source code
- [AgentBeats Documentation](https://docs.agentbeats.dev) - Platform documentation
- [A2A Protocol Specification](https://github.com/a2aproject/A2A) - Agent-to-Agent protocol

## Contact

For questions about the benchmark or leaderboard, open an issue in this repository.
