defmodule UAInspector.Database.Devices do
  @moduledoc """
  UAInspector device information database.
  """

  use UAInspector.Database

  @source_base_url "https://raw.githubusercontent.com/piwik/device-detector/master/regexes/device"

  @ets_counter :devices
  @ets_table   :ua_inspector_devices

  # files ordered according to
  # https://github.com/piwik/device-detector/blob/master/DeviceDetector.php
  # to prevent false detections
  @sources [
    { "hbbtv",   "devices.televisions.yml",           "#{ @source_base_url }/televisions.yml" },
    { "regular", "devices.consoles.yml",              "#{ @source_base_url }/consoles.yml" },
    { "regular", "devices.car_browsers.yml",          "#{ @source_base_url }/car_browsers.yml" },
    { "regular", "devices.cameras.yml",               "#{ @source_base_url }/cameras.yml" },
    { "regular", "devices.portable_media_player.yml", "#{ @source_base_url }/portable_media_player.yml" },
    { "regular", "devices.mobiles.yml",               "#{ @source_base_url }/mobiles.yml" }
  ]

  def store_entry({ brand, data }, type) do
    counter = UAInspector.Databases.update_counter(@ets_counter)
    data    = Enum.into(data, %{})
    models  = parse_models(data)

    entry = %{
      brand:  brand,
      models: models,
      regex:  Regex.compile!(data["regex"], [ :caseless ]),
      type:   type
    }

    :ets.insert_new(@ets_table, { counter, entry })
  end

  defp parse_models(data) do
    device = data["device"]

    if data["model"] do
      [%{
        device: device,
        model: data["model"],
        regex: Regex.compile!(data["regex"], [ :caseless ])
      }]
    else
      Enum.map(data["models"], fn(model) ->
        model = Enum.into(model, %{})

        %{
          device: model["device"] || device,
          model:  model["model"] || "",
          regex:  Regex.compile!(model["regex"], [ :caseless ])
        }
      end)
    end
  end
end