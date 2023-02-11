using System.Threading.Tasks;
using Jellyfin.Plugin.Danmu.Scrapers.Entity;
using MediaBrowser.Controller.Entities;
using Microsoft.Extensions.Logging;

namespace Jellyfin.Plugin.Danmu.Scrapers;

public abstract class AbstractScraper
{
    protected ILogger log;

    public virtual int DefaultOrder => 999;

    public virtual bool DefaultEnable => false;

    public abstract string Name { get; }

    /// <summary>
    /// Gets the provider name.
    /// </summary>
    public abstract string ProviderName { get; }

    /// <summary>
    /// Gets the provider id.
    /// </summary>
    public abstract string ProviderId { get; }


    public AbstractScraper(ILogger log)
    {
        this.log = log;
    }

    /// <summary>
    /// 搜索影片id
    /// </summary>
    /// <param name="item">元数据item</param>
    /// <returns>影片id</returns>
    public abstract Task<string?> SearchMediaId(BaseItem item);

    /// <summary>
    /// 获取影片信息
    /// </summary>
    /// <param name="item">元数据item</param>
    /// <param name="id">影片id</param>
    /// <returns>影片信息</returns>
    public abstract Task<ScraperMedia?> GetMedia(BaseItem item, string id);

    /// <summary>
    /// 需要更新弹幕时调用
    /// </summary>
    /// <param name="item">元数据item</param>
    /// <param name="id">元数据保存的id</param>
    /// <returns>剧集信息</returns>
    public abstract Task<ScraperEpisode?> GetMediaEpisode(BaseItem item, string id);

    /// <summary>
    /// 获取弹幕
    /// </summary>
    /// <param name="item">元数据item</param>
    /// <param name="commentId">弹幕id</param>
    /// <returns>弹幕内容</returns>
    public abstract Task<ScraperDanmaku?> GetDanmuContent(BaseItem item, string commentId);
}