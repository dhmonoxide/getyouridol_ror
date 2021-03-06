class ListController < ApplicationController
  
  def home
    
  end
  
  def search
     
     
     @idols = Idol.all.order(nameko: :asc)
     #신장
     @heightMinRangeArray = rangeArray('height', 5, 0)
     @heightMaxRangeArray = rangeArray('height', 5, 1)
     #체중
     @weightMinRangeArray = rangeArray('weight', 5, 0)
     @weightMaxRangeArray = rangeArray('weight', 5, 1)
     #b
     @bMinRangeArray = rangeArray('b', 5, 0)
     @bMaxRangeArray = rangeArray('b', 5, 1)
     #w
     @wMinRangeArray = rangeArray('w', 5, 0)
     @wMaxRangeArray = rangeArray('w', 5, 1)
     #h
     @hMinRangeArray = rangeArray('h', 5, 0)
     @hMaxRangeArray = rangeArray('h', 5, 1)
     #소속사
      @productionorunit = multipleValArray(Idol, 'productionorunit', '//', 0).sort
      #@productionorunit = Idol.select(:productionorunit).distinct.order(productionorunit: :asc)
     #hairstyle
     @hairstyle = multipleValArray(Idol, 'hairstyle','//', 0).sort
     @hairstyle2 = nonRangeArray('hairstyle2', 0)
     @hairstyle3 = nonRangeArray('hairstyle3', 0)
     #feature
     @feature = nonRangeArray('feature', 0)
     #소속사2
     @mediafromp = Idol.select(:mediafromp).distinct.order(mediafromp: :asc).pluck(:mediafromp)
     @mediafromp_1 = {}
     @mediafromp.each do |v|
       total = multipleValArray(Idol.where('mediafromp = ?', v), 'productionorunit', '//', 0).sort
       #one = Idol.where('mediafromp = ?', v).select(:productionorunit).distinct.order(productionorunit: :asc).pluck(:productionorunit)
       #two = Idol.where('mediafromp = ?', v).select(:productionorunit2).distinct.order(productionorunit2: :asc).pluck(:productionorunit2)
       #total = (one + two).uniq
       @mediafromp_1[v.to_sym] = total.select {|l| l != "0"}
     end
     respond_to do |format|
      format.html
      format.json { @idols = Idol.search(params[:term]) }
     end
  end
  
  def result
    
    @idols = Idol.all.distinct
    #이름 검색창으로부터 검색했는지 여부를 판단
    if params[:name]
      #이름
      @idols = @idols.where('nameko LIKE :name OR nameja LIKE :name OR nameen LIKE :name OR cv LIKE :name', name: "%#{params[:name]}%")
    else  
      
      #성별
      if params[:gender] != ""
        @idols = @idols.where('gender = ?', params[:gender])
      end
      
      ##{'6-8세'=>'6-8','9-11세'=>'9-11','12-14세'=>'12-14','15-17세'=>'15-17','18-19세'=>'18-19','20-24세'=>'20-24','25-29세'=>'25-29','30-34세'=>'30-34','35-40세'=>'35-40'}
      
      #연령
      if params[:age] && params[:ageUnknown]
        @ageMMarray = params[:age].split('-')
        @ageUnknown = params[:ageUnknown].to_i
      end
      if !@ageUnknown != 1
        @idols = @idols.where('age >= 0')
      end
      if params[:age] && params[:age] != "" && params[:age] != '5-41'
        @idols = @idols.where('age >= ? AND age <= ? OR age < 0', @ageMMarray[0], @ageMMarray[1])
      elsif params[:age] == '5-41'
        @idols = @idols.where('age <= ? OR age >= ?', @ageMMarray[0], @ageMMarray[1])
      else
      end
      
      #신장
      @heightUnknown = params[:heightUnknown].to_i
      if !@heightUnknown != 1
        @idols = @idols.where('height >= 0')
      end
      @idols = @idols.where('height >= ? AND height < ? OR height < 0', params[:heightMin], params[:heightMax])
      
      #체중
      @weightUnknown = params[:weightUnknown].to_i
      if @weightUnknown != 1
        @idols = @idols.where('weight >= 0')
      end
      @idols = @idols.where('weight >= ? AND weight < ? OR weight < 0', params[:weightMin], params[:weightMax])
      
      #b
      @bwhUnknown = params[:bwhUnknown].to_i
      if !@bwhUnknown != 1
        @idols = @idols.where('b >= 0 AND w >= 0 AND h >= 0')
      end
      @idols = @idols.where('b >= ? AND b < ? OR b < 0', params[:bMin], params[:bMax])
      
      #w
      @idols = @idols.where('w >= ? AND w < ? OR w < 0', params[:wMin], params[:wMax])
      
      #h
      @idols = @idols.where('h >= ? AND h < ? OR h < 0', params[:hMin], params[:hMax])
      
      #소속사
        #뮤즈는 따옴표(')를 쓰기 때문에 where 조건문에서 조건을 쌍따옴표로 감싸거나, params를 .to_s해야.
      if params[:productionorunit] != ""
        #@idols = Idol.where(productionorunit: params[:productionorunit])
        @idols = @idols.where('productionorunit LIKE :unit', unit: "%#{params[:productionorunit].to_s}%")
      end
      
      #헤어스타일
      if params[:hairstyle] != ""
        @idols = @idols.where('hairstyle LIKE :color', color: "%#{params[:hairstyle]}%")
      end
      if params[:hairstyle2] != ""
        @idols = @idols.where('hairstyle2 = ?', params[:hairstyle2])
      end
      if params[:hairstyle3] != ""
        @idols = @idols.where('hairstyle3 = ?', params[:hairstyle3])
      end
      
      #기타특징
      if params[:feature] != ""
        #@idols = @idols.where('feature = ? OR feature2 = ? OR feature3 = ?', params[:feature], params[:feature], params[:feature])
        @idols = @idols.where('feature LIKE ?', "%#{params[:feature]}%")
      end
      if params[:feature2] != ""
        #@idols = @idols.where('feature = ? OR feature2 = ? OR feature3 = ?', params[:feature2], params[:feature2], params[:feature2])
        @idols = @idols.where('feature LIKE ?', "%#{params[:feature2]}%")
      end
      if params[:feature3] != ""
        #@idols = @idols.where('feature = ? OR feature2 = ? OR feature3 = ?', params[:feature3], params[:feature3], params[:feature3])
        @idols = @idols.where('feature LIKE ?', "%#{params[:feature3]}%")
      end
      
      #소속사2
        #뮤즈는 따옴표(')를 쓰기 때문에 where 조건문에서 조건을 쌍따옴표로 감싸거나, params를 .to_s해야.
      #def production_filter(rawData, targetcolumns, keyArray)
      def production_filter(rawData, keyArray)
        #@all_key_array = []
        #for @j_prod in targetcolumns
        #  @all_key_array = @all_key_array + multipleValArray(Idol, @j_prod, '//', 0)
        #end
        #@all_key_array = @all_key_array.uniq
        #@all_key_array.select! {|v| v != "0"}
        #@notKeyArray = @all_key_array
        #if keyArray
        #  @notKeyArray = @notKeyArray - keyArray
        #end
        #for @i_prod in @notKeyArray
        @rawData = Idol.none
        for @i_prod in keyArray  
            # 아래의 union 메소드는 gem을 설치한 것임.
            @rawData = @rawData.union(rawData.where("productionorunit LIKE :unit", unit: "%#{@i_prod.to_s}%"))
            #rawData = rawData.where.not("productionorunit LIKE :unit", unit: "%#{@i_prod.to_s}%")
          
        end
        return @rawData
      end
      #@idols = production_filter(@idols, ['productionorunit'], params[:productionorunit_multisel])
      if params[:productionorunit_multisel]
        @idols = production_filter(@idols, params[:productionorunit_multisel])
      end
    
    end
    
    @idols = @idols.order(nameko: :asc)
  end
  
  def about
    
  end
  
end

#현재 search버튼을 누를 경우에, list/result로 접근하면  list controller result action으로 리디렉팅하고, 해당 액션은 변수 계산후 그것을 search.html.erb에 뿌리는 방식으로 구동
#원래대로 돌리려면, def result의 @productionorunit을 지우고, render action: 'search'를 render action: 'index'로 수정하여야 함.
#def search에서 @Idols 삭제해야함
