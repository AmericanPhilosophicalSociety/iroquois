<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0">
   
   
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Search forms stylesheet                                                -->
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   
   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   
   <!-- ====================================================================== -->
   <!-- Global parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:param name="freeformQuery"/>
   
   <!-- ====================================================================== -->
   <!-- Form Templates                                                         -->
   <!-- ====================================================================== -->
   
   <!-- main form page -->
   <xsl:template match="crossQueryResult" mode="form" exclude-result-prefixes="#all">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
         <head>
            <title>American Philosophical Society Native American Guide</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
		 <script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-5674777-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
		 


         <body>
            <xsl:copy-of select="$brand.header"/>
            <div class="searchPage">
               <div class="forms">
                  <table>
                     <tr>
                        <td class="{if(matches($smode,'simple')) then 'tab-select' else 'tab'}"></td>
                       
                        
                       
                     </tr>
                     <tr>
                        <td colspan="4">
                           <div class="form">
                              <xsl:choose>
                                 <xsl:when test="matches($smode,'simple')">
                                    <xsl:call-template name="simpleForm"/>
                                 </xsl:when>
                                 <xsl:when test="matches($smode,'advanced')">
                                    <xsl:call-template name="simpleForm"/>
                                 </xsl:when>
                                 <xsl:when test="matches($smode,'freeform')">
                                    <xsl:call-template name="simpleForm"/>
                                 </xsl:when>
                                 <xsl:when test="matches($smode,'browse')">
                                    
                                 </xsl:when>
                              </xsl:choose>
                           </div>
                        </td>
                     </tr>
                  </table>
				  
               </div>
			   
            </div>
			
            <xsl:copy-of select="$brand.footer"/>
			
			<!-- Google analytics code - remove if it causes problems -->			
			<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-5674777-1");
pageTracker._trackPageview();
</script>

         </body>
      </html>
   </xsl:template>
   
   <!-- simple form -->
   <xsl:template name="simpleForm" exclude-result-prefixes="#all">
   
   <table>
   <tr><td colspan="3"><b><center>View <a href="http://www.amphilsoc.org/library/natam/intro">Introduction</a> and the <a href="http://www.amphilsoc.org/library/natam/bibliography">Bibliography</a> from the original guide.</center></b></td></tr>
   <tr><td colspan="3">&#160;</td></tr>
   <tr>
   <td class="half"><b><center>SEARCH</center></b></td>
   <td class="spacer">&#160;</td>
   <td class="half"><b><center>BROWSE</center></b></td>
   </tr>
   <tr><td colspan="3">&#160;</td></tr>
   <tr>
   <td class="half">
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
	  
         <table class="top_table">
            

					 <tr>
					 <td class="indent">&#160;</td>
					 <td class="right"><b>Keyword</b></td>
                  
                        <td align="left">
                           <input type="text" name="freeformQuery" size="40" value="{$freeformQuery}"/>
						
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
						<td></td>
                        <td>
                           <xsl:choose>
                              <xsl:when test="$text-join = 'or'">
                                 <input type="radio" name="text-join" value=""/>
                                 <xsl:text> all of </xsl:text>
                                 <input type="radio" name="text-join" value="or" checked="checked"/>
                                 <xsl:text> any of </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <input type="radio" name="text-join" value="" checked="checked"/>
                                 <xsl:text> all of </xsl:text>
                                 <input type="radio" name="text-join" value="or"/>
                                 <xsl:text> any of </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:text>these words</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="right"><b>Exclude</b></td>
                        <td>
                           <input type="text" name="text-exclude" size="20" value="{$text-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="right"><b>Proximity</b></td>
                        <td>
                           <select size="1" name="text-prox">
                              <xsl:choose>
                                 <xsl:when test="$text-prox = '1'">
                                    <option value=""></option>
                                    <option value="1" selected="selected">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '2'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2" selected="selected">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '3'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3" selected="selected">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '4'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4" selected="selected">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '5'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5" selected="selected">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '10'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10" selected="selected">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '20'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20" selected="selected">20</option>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <option value="" selected="selected"></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </select>
                           <xsl:text> word(s)</xsl:text>
                        </td>
                     </tr>  
					 <tr>
					 <td colspan="3">&#160;</td></tr>
					 
					 
<tr>
                        <td class="indent">&#160;</td>
                        <td class="right"><b>Year(s)</b></td>
                        <td>
                           <xsl:text>From </xsl:text>
                           <input type="text" name="year" size="4" value="{$year}"/>
                           <xsl:text> to </xsl:text>
                           <input type="text" name="year-max" size="4" value="{$year-max}"/>
                        </td>
                     </tr>		
 <tr>
                        <td class="indent">&#160;</td>
                        <td>&#160;</td>
                        <td>
                           <input type="hidden" name="smode" value="simple"/>
                           <input type="submit" value="Search"/>
                           <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}?smode=simple'" value="Clear"/>
                        </td>
                     </tr>					 
                  
         </table>
		 
      </form>
	  </td>
	  <td class="spacer">&#160;</td>
	  <td>
	   <table>
                                       <tr>
                                          <td><center>
                                             <p>Helpful text here if we need any.</p>
                                          </center></td>
                                       </tr>
                                       <tr>
                                          <td><center><b>
                                             <xsl:call-template name="browseLinks"/></b>
                                          </center></td>
                                       </tr>
                                    </table>
	  </td>
	  </tr>
	  </table>
   </xsl:template>
   
   <!-- simple form2 -->
   <xsl:template name="simpleForm2" exclude-result-prefixes="#all">
   
   <table>

   
   <tr>
   <td>
      <form method="get" action="{$xtfURL}{$crossqueryPath}">
	  
         <table class="top_table">
            

					 <tr>
					 <td class="indent">&#160;</td>
					 <td class="right"><b>Keyword</b></td>
                  
                        <td align="left">
                           <input type="text" name="freeformQuery" size="40" value="{$freeformQuery}"/>
						
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
						<td></td>
                        <td>
                           <xsl:choose>
                              <xsl:when test="$text-join = 'or'">
                                 <input type="radio" name="text-join" value=""/>
                                 <xsl:text> all of </xsl:text>
                                 <input type="radio" name="text-join" value="or" checked="checked"/>
                                 <xsl:text> any of </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <input type="radio" name="text-join" value="" checked="checked"/>
                                 <xsl:text> all of </xsl:text>
                                 <input type="radio" name="text-join" value="or"/>
                                 <xsl:text> any of </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:text>these words</xsl:text>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="right"><b>Exclude</b></td>
                        <td>
                           <input type="text" name="text-exclude" size="20" value="{$text-exclude}"/>
                        </td>
                     </tr>
                     <tr>
                        <td class="indent">&#160;</td>
                        <td class="right"><b>Proximity</b></td>
                        <td>
                           <select size="1" name="text-prox">
                              <xsl:choose>
                                 <xsl:when test="$text-prox = '1'">
                                    <option value=""></option>
                                    <option value="1" selected="selected">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '2'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2" selected="selected">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '3'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3" selected="selected">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '4'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4" selected="selected">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '5'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5" selected="selected">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '10'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10" selected="selected">10</option>
                                    <option value="20">20</option>
                                 </xsl:when>
                                 <xsl:when test="$text-prox = '20'">
                                    <option value=""></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20" selected="selected">20</option>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <option value="" selected="selected"></option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </select>
                           <xsl:text> word(s)</xsl:text>
                        </td>
                     </tr>  
					 <tr>
					 <td colspan="3">&#160;</td></tr>
					 
					 
<tr>
                        <td class="indent">&#160;</td>
                        <td class="right"><b>Year(s)</b></td>
                        <td>
                           <xsl:text>From </xsl:text>
                           <input type="text" name="year" size="4" value="{$year}"/>
                           <xsl:text> to </xsl:text>
                           <input type="text" name="year-max" size="4" value="{$year-max}"/>
                        </td>
                     </tr>		
 <tr>
                        <td class="indent">&#160;</td>
                        <td>&#160;</td>
                        <td>
                           <input type="hidden" name="smode" value="simple"/>
                           <input type="submit" value="Search"/>
                           <input type="reset" onclick="location.href='{$xtfURL}{$crossqueryPath}?smode=simple'" value="Clear"/>
                        </td>
                     </tr>					 
                  
         </table>
		 
      </form>
	  </td>
	  </tr>
	  </table>
   </xsl:template>
   
</xsl:stylesheet>
