// 生成 i18n 翻译表格 (.xlsx)，无第三方依赖，纯 Node 手写 OOXML + ZIP(store)。
const fs = require("fs");
const path = require("path");
const zlib = require("zlib");

// [模块, Key常量名, Key标识, 中文, 备注]
const ROWS = [
  ["通用", "commonSearchInput", "common_search_input", "输入关键字", ""],
  ["通用", "commonBottomSave", "common_bottom_save", "保存", ""],
  ["通用", "commonBottomRemove", "common_bottom_remove", "删除", ""],
  ["通用", "commonBottomCancel", "common_bottom_cancel", "取消", ""],
  ["通用", "commonBottomConfirm", "common_bottom_confirm", "确认", ""],
  ["通用", "commonBottomApply", "common_bottom_apply", "应用", ""],
  ["通用", "commonBottomBack", "common_bottom_back", "返回", ""],
  ["通用", "commonSelectTips", "common_select_tips", "请选择", ""],
  ["通用", "commonMessageSuccess", "common_message_success", "@method 成功", "保留 @method 占位符，不要翻译"],
  ["通用", "commonMessageIncorrect", "common_message_incorrect", "@method 不正确", "保留 @method 占位符，不要翻译"],
  ["通用", "commonNext", "common_next", "下一页", ""],
  ["通用", "commonEdit", "common_edit", "编辑", ""],
  ["通用", "commonEditPlaceholder", "common_edit_placeholder", "请输入", ""],
  ["通用", "selectLanguage", "select_language", "选择语言", ""],
  ["通用", "selectCountry", "select_country", "选择国家", ""],
  ["通用", "searchCountry", "search_country", "搜索国家或区号", ""],

  ["登录/注册-通用", "loginForgotPassword", "login_forgot_password", "忘记密码?", ""],
  ["登录/注册-通用", "loginSignIn", "login_sign_in", "登 陆", ""],
  ["登录/注册-通用", "loginSignUp", "login_sign_up", "注 册", ""],

  ["注册", "commonLanguage", "common_language", "常用语言", ""],
  ["注册", "phonePlaceholder", "phone_placeholder", "请输入手机号", ""],
  ["注册", "verifyCode", "verify_code", "验证码", ""],
  ["注册", "verifyPlaceHolder", "verify_placeholder", "请输入验证码", ""],
  ["注册", "getVerifyCode", "get_verify_code", "获取验证码", ""],
  ["注册", "loginPassword", "login_password", "登录密码", ""],
  ["注册", "confirmPassword", "confirm_password", "确认密码", ""],
  ["注册", "welcome", "Welcome", "欢迎您!", ""],
  ["注册", "welcomeDesc", "welcomeDesc", "来填写您的资料吧!", ""],

  ["登录", "usernamePlaceholder", "username_placeholder", "请输入账号", ""],
  ["登录", "passwordPlaceholder", "password_placeholder", "请输入密码", ""],
  ["登录", "agreeTerms", "agree_terms", "我已阅读并同意", ""],
  ["登录", "userAgreement", "user_agreement", "用户协议", ""],
  ["登录", "privacyPolicy", "privacy_policy", "隐私政策", ""],

  ["APP导航", "tabBarHome", "tab_bar_home", "首页", ""],
  ["APP导航", "tabBarPosts", "tab_bar_posts", "圈子", ""],
  ["APP导航", "tabBarMessage", "tab_bar_message", "消息", ""],
  ["APP导航", "tabBarProfile", "tab_bar_profile", "我的", ""],

  ["首页", "certification", "certification", "精英认证", ""],
  ["首页", "safeDating", "safe_dating", "安全认证", ""],
  ["首页", "reliable", "reliable", "真实", ""],
  ["首页", "viewNow", "view_now", "立即查看", ""],
  ["首页", "tab_1", "recommend", "推荐", ""],
  ["首页", "tab_2", "same_city", "同城", ""],
  ["首页", "tab_3", "new_user", "新用户", ""],
  ["首页", "highlyTrustedMatch", "highly_trusted_match", "高度信任匹配", ""],
  ["首页", "qualification", "qualification", "您安全资质已核验 @size 项", "保留 @size 占位符，不要翻译"],
  ["首页", "apply", "apply", "发起核验申请", ""],
  ["首页", "improve", "improve", "完善我的资质", ""],
  ["首页", "viewApplication", "view_application", "申请查看报告", ""],
  ["首页", "sayHi", "say_hi", "打招呼", ""],
  ["首页", "tag1", "tag1", "实名", ""],
  ["首页", "tag2", "tag2", "健康", ""],
  ["首页", "tag3", "tag3", "纳税", ""],
  ["首页", "tag4", "tag4", "信用", ""],

  ["消息页", "message", "message", "消息", ""],
  ["消息页", "search", "search", "请输入关键字搜索", ""],
  ["消息页", "report", "report", "申请报告", ""],
  ["消息页", "check", "check", "申请查看", ""],
  ["消息页", "loveFourTitle1", "love_four_title_1", "职业认证", ""],
  ["消息页", "loveFourTitle2", "love_four_title_2", "个人纳税", ""],
  ["消息页", "loveFourTitle3", "love_four_title_3", "个人信用", ""],
  ["消息页", "content", "content ", "请输入消息内容", ""],
  ["消息页", "uploadReport", "upload_report", "请上传您的安全报告", ""],
  ["消息页", "complete", "complete", "完成", ""],

  ["圈子", "circle", "circle", "圈子", ""],
  ["圈子", "hotTopic", "hot_topic", "热门话题", ""],
  ["圈子", "post", "post", "圈子", ""],
  ["圈子", "share", "share", "分享美好倾吐焦虑", ""],
  ["圈子", "expand", "expand", "展开", ""],
  ["圈子", "collapse", "collapse", "收起", ""],
  ["圈子", "look", "look", "看看大家", ""],
  ["圈子", "follow", "follow", "关注", ""],
  ["圈子", "unfollow", "unfollow", "取消关注", ""],
  ["圈子", "sendFeed", "send_feed", "发布动态", ""],
  ["圈子", "comment", "comment", "评论", ""],

  ["圈子详情", "detail", "detail", "详情", ""],
  ["圈子详情", "reply", "reply", "回复", ""],

  ["我的", "userCenter", "user_center", "个人中心", ""],
  ["我的", "fans", "fans", "粉丝", ""],
  ["我的", "lookMe", "look_me", "看过我", ""],
  ["我的", "lookedMe", "looked_me", "我看过", ""],
  ["我的", "likeMe", "like_me", "喜欢我", ""],
  ["我的", "likedMe", "liked_me", "我喜欢", ""],
  ["我的", "myImage", "my_image", "我的形象", ""],
  ["我的", "editImage", "edit_image", "编辑形象", ""],

  ["编辑个人信息", "editProfile", "edit_profile", "编辑个人信息", ""],
  ["编辑个人信息", "showcaseWall", "showcase_wall", "展示墙", ""],
  ["编辑个人信息", "profile", "profile", "个人资料", ""],
  ["编辑个人信息", "datingProfile", "dating_profile", "交友资料", ""],

  ["个人资料", "nickname", "nickname", "昵称", ""],
  ["个人资料", "introduction", "introduction", "简介", ""],
  ["个人资料", "gender", "gender", "性别", ""],
  ["个人资料", "birth", "birth", "生日", ""],
  ["个人资料", "height", "height", "身高", ""],
  ["个人资料", "weight", "weight", "体重", ""],
  ["个人资料", "personalityTags", "personality_tags", "职业技能", ""],
  ["个人资料", "identityVerification", "identity_verification", "身份验证", ""],
  ["个人资料", "man", "man", "男", ""],
  ["个人资料", "woman", "woman", "女", ""],

  ["设置", "messageNotification", "message_notification", "消息通知", ""],
  ["设置", "locationService", "location_service", "位置服务", ""],
  ["设置", "personalizedRecommendation", "personalized_recommendation", "个性化推荐", ""],
  ["设置", "teenMode", "teen_mode", "青少年模式", ""],
  ["设置", "aboutUs", "about_us", "关于我们", ""],
  ["设置", "logout", "logout", "退出登录", ""],
];

const HEADERS = ["模块", "Key(常量名)", "Key(标识)", "中文(原文)", "English(待翻译)", "备注"];

const xmlEscape = (s) =>
  String(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");

const colLetter = (n) => String.fromCharCode(64 + n); // 1->A

// ---- 构建各个 XML 部件 ----
function buildSheet() {
  const totalRows = ROWS.length + 1;
  let rowsXml = "";

  // 表头
  let head = `<row r="1">`;
  HEADERS.forEach((h, i) => {
    head += `<c r="${colLetter(i + 1)}1" s="1" t="inlineStr"><is><t xml:space="preserve">${xmlEscape(h)}</t></is></c>`;
  });
  head += `</row>`;
  rowsXml += head;

  // 数据行
  ROWS.forEach((row, ri) => {
    const r = ri + 2;
    let cells = `<row r="${r}">`;
    row.forEach((val, ci) => {
      // 备注列(第6列)有内容时用高亮样式2，其余数据用换行样式3
      const style = ci === 5 && val ? 2 : 3;
      cells += `<c r="${colLetter(ci + 1)}${r}" s="${style}" t="inlineStr"><is><t xml:space="preserve">${xmlEscape(val)}</t></is></c>`;
    });
    cells += `</row>`;
    rowsXml += cells;
  });

  const cols =
    `<cols>` +
    [16, 26, 26, 28, 30, 34]
      .map((w, i) => `<col min="${i + 1}" max="${i + 1}" width="${w}" customWidth="1"/>`)
      .join("") +
    `</cols>`;

  return `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<sheetViews><sheetView workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews>
<sheetFormatPr defaultRowHeight="18"/>
${cols}
<sheetData>${rowsXml}</sheetData>
<autoFilter ref="A1:F${totalRows}"/>
</worksheet>`;
}

const STYLES = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<fonts count="2">
<font><sz val="11"/><name val="Calibri"/></font>
<font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font>
</fonts>
<fills count="4">
<fill><patternFill patternType="none"/></fill>
<fill><patternFill patternType="gray125"/></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FF4F81BD"/></patternFill></fill>
<fill><patternFill patternType="solid"><fgColor rgb="FFFFF2CC"/></patternFill></fill>
</fills>
<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
<cellXfs count="4">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>
<xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center"/></xf>
<xf numFmtId="0" fontId="0" fillId="3" borderId="0" xfId="0" applyFill="1" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>
</cellXfs>
<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
</styleSheet>`;

const CONTENT_TYPES = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
</Types>`;

const ROOT_RELS = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>`;

const WORKBOOK = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<sheets><sheet name="翻译文案" sheetId="1" r:id="rId1"/></sheets>
</workbook>`;

const WORKBOOK_RELS = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>`;

// ---- 最简 ZIP(store/deflate) 打包 ----
const CRC_TABLE = (() => {
  const t = new Uint32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    t[n] = c >>> 0;
  }
  return t;
})();
function crc32(buf) {
  let c = 0xffffffff;
  for (let i = 0; i < buf.length; i++) c = CRC_TABLE[(c ^ buf[i]) & 0xff] ^ (c >>> 8);
  return (c ^ 0xffffffff) >>> 0;
}

function zip(files) {
  const chunks = [];
  const central = [];
  let offset = 0;
  for (const f of files) {
    const nameBuf = Buffer.from(f.name, "utf8");
    const data = Buffer.from(f.data, "utf8");
    const comp = zlib.deflateRawSync(data);
    const crc = crc32(data);

    const local = Buffer.alloc(30);
    local.writeUInt32LE(0x04034b50, 0);
    local.writeUInt16LE(20, 4);
    local.writeUInt16LE(0x0800, 6); // UTF-8 flag
    local.writeUInt16LE(8, 8); // deflate
    local.writeUInt16LE(0, 10);
    local.writeUInt16LE(0, 12);
    local.writeUInt32LE(crc, 14);
    local.writeUInt32LE(comp.length, 18);
    local.writeUInt32LE(data.length, 22);
    local.writeUInt16LE(nameBuf.length, 26);
    local.writeUInt16LE(0, 28);
    chunks.push(local, nameBuf, comp);

    const cen = Buffer.alloc(46);
    cen.writeUInt32LE(0x02014b50, 0);
    cen.writeUInt16LE(20, 4);
    cen.writeUInt16LE(20, 6);
    cen.writeUInt16LE(0x0800, 8);
    cen.writeUInt16LE(8, 10);
    cen.writeUInt16LE(0, 12);
    cen.writeUInt16LE(0, 14);
    cen.writeUInt32LE(crc, 16);
    cen.writeUInt32LE(comp.length, 20);
    cen.writeUInt32LE(data.length, 24);
    cen.writeUInt16LE(nameBuf.length, 28);
    cen.writeUInt16LE(0, 30);
    cen.writeUInt16LE(0, 32);
    cen.writeUInt16LE(0, 34);
    cen.writeUInt16LE(0, 36);
    cen.writeUInt32LE(0, 38);
    cen.writeUInt32LE(offset, 42);
    central.push(Buffer.concat([cen, nameBuf]));

    offset += local.length + nameBuf.length + comp.length;
  }
  const centralBuf = Buffer.concat(central);
  const end = Buffer.alloc(22);
  end.writeUInt32LE(0x06054b50, 0);
  end.writeUInt16LE(files.length, 8);
  end.writeUInt16LE(files.length, 10);
  end.writeUInt32LE(centralBuf.length, 12);
  end.writeUInt32LE(offset, 16);
  return Buffer.concat([...chunks, centralBuf, end]);
}

const files = [
  { name: "[Content_Types].xml", data: CONTENT_TYPES },
  { name: "_rels/.rels", data: ROOT_RELS },
  { name: "xl/workbook.xml", data: WORKBOOK },
  { name: "xl/_rels/workbook.xml.rels", data: WORKBOOK_RELS },
  { name: "xl/styles.xml", data: STYLES },
  { name: "xl/worksheets/sheet1.xml", data: buildSheet() },
];

const out = path.join(__dirname, "..", "docs", "i18n_translation.xlsx");
fs.writeFileSync(out, zip(files));
console.log(`OK rows=${ROWS.length} -> ${out}`);
