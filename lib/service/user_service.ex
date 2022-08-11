defmodule Exmock.Service.User do
  use Exmock.Common.ErrorCode
  use Ezx.Service


  require Logger

  @doc """
  user.basicinfo
  """
  def get("basicinfo", %{"uid" => uid} = params) do
    case UserBasicInfoRepo.query_user_basicinfo_by_id(uid) do
      nil ->
        fail(@ecode_not_found)
      {:fail, reason} ->
        fail(@ecode_db_error)
      re ->
        ok(data: re)
    end
  end

  @doc """
  user.info
  """
  def get("info", %{"uid" => uid, "lang" => _lang} = params) do
    case UserInfoRepo.query_user_info_by_id(uid) do
      nil ->
        fail(@ecode_not_found)
      {:fail, reason} ->
        fail(@ecode_db_error)
      re ->
        ok(data: re)
    end
  end

  @doc """
  req demo:
  users = [%{"language" => "en", "uid" => 26101619061944320}]
  users |> Jason.encode!() |> URI.encode_www_form()
  """
  def get("batchInfo", %{"users" => users_url_encoded} = params) do
    real_users =
      users_url_encoded
      |> URI.decode()
      |> Jason.decode!()

    ids = real_users
          |> Enum.map(fn %{"uid" => uid} -> uid end)

    case UserInfoRepo.batch_query_user_info_by_ids(ids) do
      {:fail, reason} ->
        fail(@ecode_db_error)
      re ->
        ok(data: re)
    end
  end


  ### post ###
  def post("info", _params) do
    user_info_data = %{uid: uid} = AutoGen.UserInfoStructs.new()

    user_info = %User.UserInfo{
      uid: uid,
      data: user_info_data
            |> :erlang.term_to_binary()
    }

    case UserInfoRepo.insert_user_info(user_info) do
      {:fail, reason} ->
        fail(@ecode_db_error)
      re ->
        ok(data: re)
    end
  end

end
