# frozen_string_literal: true

require 'test_helper'

class Playlists::SongsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @playlist = playlists(:playlist1)
    @user = @playlist.user
  end

  test 'should add songs to playlist' do
    assert_login_access(user: @user, method: :post, url: playlist_song_url(@playlist), params: { song_ids: [3] }, xhr: true) do
      assert_equal [1, 2, 3], @playlist.reload.song_ids
    end

    assert_login_access(user: @user, method: :post, url: playlist_song_url(@playlist), params: { song_ids: [4, 5] }, xhr: true) do
      assert_equal [1, 2, 3, 4, 5], @playlist.reload.song_ids
    end
  end

  test 'should remove songs from playlist' do
    assert_login_access(user: @user, method: :delete, url: playlist_song_url(@playlist), params: { song_ids: [1] }, xhr: true) do
      assert_equal [2], @playlist.reload.song_ids
    end

    assert_login_access(user: @user, method: :delete, url: playlist_song_url(@playlist), params: { song_ids: [2, 3] }, xhr: true) do
      assert_equal [], @playlist.reload.song_ids
    end
  end

  test 'should clear all songs from playlist' do
    assert_login_access(user: @user, method: :delete, url: playlist_song_url(@playlist), params: { clear_all: true }, xhr: true) do
      assert_equal [], @playlist.reload.song_ids
    end
  end
end
