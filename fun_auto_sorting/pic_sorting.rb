#encoding: utf-8
require "rubygems"
require "fileutils"
require "exifr"


def move_file(s_path,d_path,fname)

  e_name=File.extname(fname).upcase
  b_name=File.basename(fname,e_name)

  if e_name =='.MP4' || e_name =='.MOV' then 
    pic_path=d_path+'\\video'
    Dir::mkdir(pic_path) if !File.directory?(pic_path)
    FileUtils.move(s_path+'\\'+fname,pic_path+'\\'+fname)
    puts s_path+'\\'+fname+' --> '+pic_path+'\\'+fname
    return
  end

  if e_name !='.JPG' then 
    return
  end

  f=EXIFR::JPEG.new(s_path+'\\'+fname)
  if f.model == nil then
    pic_path=d_path+'\\unknow_device'
    Dir::mkdir(pic_path) if !File.directory?(pic_path)
    FileUtils.move(s_path+'\\'+fname,pic_path+'\\'+fname)
    puts s_path+'\\'+fname+' --> '+pic_path+'\\'+fname
    return
  end
  pic_phone=f.model

  if !f.exif? || f.exif.date_time_original == nil then
    pic_path=d_path+'\\'+pic_phone+'\\unknow_date'
    Dir::mkdir(pic_path) if !File.directory?(pic_path)
    FileUtils.move(s_path+'\\'+fname,pic_path+'\\'+fname)
    puts s_path+'\\'+fname+' --> '+pic_path+'\\'+fname
    return
  end
  pic_date=f.exif.date_time_original.strftime("%Y-%m")

  # 型号目录
  pic_path=d_path+'\\'+pic_phone
  Dir::mkdir(pic_path) if !File.directory?(pic_path)
  
  # 日期目录
  pic_path=d_path+'\\'+pic_phone+'\\'+pic_date
  Dir::mkdir(pic_path) if !File.directory?(pic_path)
  
  # 复制
  FileUtils.move(s_path+'\\'+fname,d_path+'\\'+pic_phone+'\\'+pic_date+'\\'+fname)
  puts s_path+'\\'+fname+' --> '+d_path+'\\'+pic_phone+'\\'+pic_date+'\\'+fname
end

def auto_sorting(s_path, d_path)
  Dir::foreach(s_path) do |fname|
    if fname=='.' || fname=='..' then
      next
    end
    tmpdir=s_path+'\\'+fname
    if File.directory?(tmpdir) then
      auto_sorting(tmpdir, d_path) 
    else
      move_file(s_path, d_path, fname)
    end
  end
end

# 需要整理的源目录
s_path='E:\照相摄像'
# 整理存放的新目录
d_path='E:\photo1'
Dir::mkdir(d_path) if !File.directory?(d_path)
auto_sorting(s_path, d_path)
