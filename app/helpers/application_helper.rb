module ApplicationHelper
    def format_datetime(datetime_str)
        datetime = Time.parse(datetime_str)
    
        def ordinal_suffix(day)
            if (11..13).include?(day % 100)
            "th"
            else
            case day % 10
            when 1
                "st"
            when 2
                "nd"
            when 3
                "rd"
            else
                "th"
            end
            end
        end

        datetime.strftime("%A, #{datetime.day}#{ordinal_suffix(datetime.day)} %B %Y")
    end

    def body_background
        if @weather
            if @weather[:current_weather]['current']['condition']['text'].downcase.include?('sunny')
                'bg-[#FFE772]'
            else
                'bg-[#CADDFD]'
            end 
        else
          'bg-[#DEF0FE]'
        end
    end

    def get_weather_svg
        
    end 
end


  