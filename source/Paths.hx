package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxDestroyUtil;
import openfl.media.Sound;
import openfl.utils.Assets;

class Paths
{
	public static final extensions:Map<String, String> = ["image" => "png", "audio" => "ogg", "video" => "mp4"];

	private static var imagesCache:Map<String, FlxGraphic> = [];
	private static var soundsCache:Map<String, Sound> = [];

	public static function clearCachedAssets(type:String = 'none'):Void
	{
		if (type == 'graphics')
		{
			@:privateAccess
			for (key in FlxG.bitmap._cache.keys())
			{
				var obj:Null<FlxGraphic> = FlxG.bitmap._cache.get(key);
				if (obj != null && imagesCache.exists(key))
				{
					GPUBitmap.dispose(KEY(key));

					if (Assets.cache.hasBitmapData(key))
						Assets.cache.removeBitmapData(key);

					FlxG.bitmap._cache.remove(key);
					obj = FlxDestroyUtil.destroy(obj);
					imagesCache.remove(key);
				}
			}
		}
		else if (type == 'music')
		{
			for (key in Assets.cache.getSoundKeys())
			{
				var obj:Sound = Assets.cache.getSound(key);
				if (obj != null && soundsCache.exists(key))
				{
					Assets.cache.removeSound(key);
					obj.close();
					soundsCache.remove(key);
				}
			}
		}
		else if (type == 'none')
			trace('no cached assets clearing!');
	}

	inline static public function file(key:String, location:String, extension:String):String
	{
		var path:String = 'assets/$location/$key.$extension';
		return path;
	}

	inline static public function font(key:String, ?extension:String = "ttf"):String
	{
		var path:String = file(key, "fonts", extension);
		return path;
	}

	inline static public function xml(key:String, ?location:String = "data"):String
	{
		var path:String = file(key, location, "xml");
		return path;
	}

	inline static public function text(key:String, ?location:String = "data"):String
	{
		var path:String = file(key, location, "txt");
		return path;
	}

	inline static public function json(key:String, ?location:String = "data"):String
	{
		var path:String = file(key, location, "json");
		return path;
	}

	inline static public function image(key:String, ?location:String = "images"):FlxGraphic
	{
		var path:String = file(key, location, extensions.get("image"));
		return loadImage(path);
	}

	inline static public function sound(key:String, ?location:String = "sounds"):Sound
	{
		var path:String = file(key, location, extensions.get("audio"));
		return loadSound(path);
	}

	inline static public function music(key:String, ?location:String = "music"):Sound
	{
		var path:String = file(key, location, extensions.get("audio"));
		return loadSound(path);
	}

	inline static public function voices(key:String, ?location:String = "songs"):Sound
	{
		var path:String = file('$key/Voices', location, extensions.get("audio"));
		return loadSound(path);
	}

	inline static public function inst(key:String, ?location:String = "songs"):Sound
	{
		var path:String = file('$key/Inst', location, extensions.get("audio"));
		return loadSound(path);
	}

	inline static public function video(key:String, ?location:String = "videos"):String
	{
		var path:String = file(key, location, extensions.get("video"));
		return path;
	}

	inline static public function getSparrowAtlas(key:String, ?location:String = "images"):FlxAtlasFrames
		return FlxAtlasFrames.fromSparrow(image(key, location), xml(key, location));

	inline static public function getPackerAtlas(key:String, ?location:String = "images"):FlxAtlasFrames
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, location), text(key, location));

	public static function loadImage(path:String, ?addToCache:Bool = false):FlxGraphic
	{
		if (Assets.exists(path, IMAGE))
		{
			if (addToCache)
			{
				if (!imagesCache.exists(path))
				{
					var graphic:FlxGraphic = FlxGraphic.fromBitmapData(GPUBitmap.create(path));
					graphic.persist = true;
					graphic.destroyOnNoUse = false;
					imagesCache.set(path, graphic);
				}
				else
					trace('$path is already loaded to the cache!');

				return imagesCache.get(path);
			}
			else
				return FlxGraphic.fromAssetKey(path);
		}
		else
			trace('$path is null!');

		return null;
	}

	public static function loadSound(path:String, ?addToCache:Bool = false):Sound
	{
		if (Assets.exists(path, SOUND))
		{
			if (addToCache)
			{
				if (!soundsCache.exists(path))
					soundsCache.set(path, Assets.getSound(path));
				else
					trace('$path is already loaded to the cache!');

				return soundsCache.get(path);
			}
			else
				return Assets.getSound(path);
		}
		else
			trace('$path is null!');

		return null;
	}
}
