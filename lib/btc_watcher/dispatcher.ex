defmodule BtcWatcher.Dispatcher do
  require Logger

  @base_url Application.get_env(:btc_watcher, :api_url)

  def dispatch(tx) when is_nil(tx), do: nil
  def dispatch(tx) do
    unless Mix.env() == :test, do: post(tx)
  end

  defp post(msg) do
    headers = [{"Content-Type", "application/vnd.api+json"}, {"Chainspark-secret", "123"}]

    with {:ok, payload} <- Poison.encode(msg),
         {:ok, _} <- HTTPoison.post(@base_url, payload, headers)
    do
      Logger.info "Transaction posted"
    else
      error -> Logger.error error
    end
  end
end
