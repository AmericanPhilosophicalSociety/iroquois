<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   xmlns:editURL="http://cdlib.org/xtf/editURL"
   xmlns="http://www.w3.org/1999/xhtml"
   extension-element-prefixes="session"
   exclude-result-prefixes="#all"
   version="2.0">

  <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
  <!-- Query result formatter stylesheet                                      -->
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

  <!-- this stylesheet implements very simple search forms and query results. 
      Alpha and facet browsing are also included. Formatting has been kept to a 
      minimum to make the stylesheets easily adaptable. -->

  <!-- ====================================================================== -->
  <!-- Import Common Templates                                                -->
  <!-- ====================================================================== -->

  <xsl:import href="../common/resultFormatterCommon.xsl"/>
  <xsl:include href="searchForms.xsl"/>

  <!-- ====================================================================== -->
  <!-- Output                                                                 -->
  <!-- ====================================================================== -->

  <xsl:output method="xhtml" indent="no" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      omit-xml-declaration="yes"
      exclude-result-prefixes="#all"/>

  <!-- ====================================================================== -->
  <!-- Local Parameters                                                       -->
  <!-- ====================================================================== -->

  <xsl:param name="css.path" select="concat($xtfURL, 'css/default/')"/>
  <xsl:param name="icon.path" select="concat($xtfURL, 'icons/default/')"/>
  <xsl:param name="docHits" select="/crossQueryResult/docHit"/>
  <xsl:param name="email"/>

  <!-- ====================================================================== -->
  <!-- Root Template                                                          -->
  <!-- ====================================================================== -->

  <xsl:template match="/" exclude-result-prefixes="#all">
    <xsl:choose>
      <!-- robot response -->
      <xsl:when test="matches($http.User-Agent,$robots)">
        <xsl:apply-templates select="crossQueryResult" mode="robot"/>
      </xsl:when>
      <xsl:when test="$smode = 'showBag'">
        <xsl:apply-templates select="crossQueryResult" mode="results"/>
      </xsl:when>
      <!-- book bag -->
      <xsl:when test="$smode = 'addToBag'">
        <span>Added</span>
      </xsl:when>
      <xsl:when test="$smode = 'removeFromBag'">
        <!-- no output needed -->
      </xsl:when>
      <xsl:when test="$smode='getAddress'">
        <xsl:call-template name="getAddress"/>
      </xsl:when>
      <xsl:when test="$smode='emailFolder'">
        <xsl:apply-templates select="crossQueryResult" mode="emailFolder"/>
      </xsl:when>
      <!-- similar item -->
      <xsl:when test="$smode = 'moreLike'">
        <xsl:apply-templates select="crossQueryResult" mode="moreLike"/>
      </xsl:when>
      <!-- modify search -->
      <xsl:when test="contains($smode, '-modify')">
        <xsl:apply-templates select="crossQueryResult" mode="form"/>
      </xsl:when>
      <!-- browse pages -->
      <xsl:when test="$browse-tribe or $browse-title or $browse-clan">
        <xsl:apply-templates select="crossQueryResult" mode="browse"/>
      </xsl:when>
      <!-- show results -->
      <xsl:when test="crossQueryResult/query/*/*">
        <xsl:apply-templates select="crossQueryResult" mode="results"/>
      </xsl:when>
      <!-- show form -->
      <xsl:otherwise>
        <xsl:apply-templates select="crossQueryResult" mode="form"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Results Template                                                       -->
  <!-- ====================================================================== -->

  <xsl:template match="crossQueryResult" mode="results" exclude-result-prefixes="#all">

    <!-- modify query URL -->
    <xsl:variable name="modify" select="if(matches($smode,'simple')) then 'simple-modify' else 'simple-modify'"/>
    <xsl:variable name="modifyString" select="editURL:set($queryString, 'smode', $modify)"/>

    <html xml:lang="en" lang="en">
      <head>
        <title>American Philosophical Society Names Database</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="description" content="Resources in native american studies at the American Philosophical Society"/>
        <meta name="keywords" content="anthropology, manuscripts, archives, resources, guides, archeology, ethnography, linguistics"/>
        <xsl:copy-of select="$brand.links"/>
        <!-- AJAX support -->
        <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
        <script src="script/yui/connection-min.js" type="text/javascript"/> 
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

        <!-- header -->
        <xsl:copy-of select="$brand.header"/>

        <!-- result header -->
        <div class="resultsHeader">
          <table>
            <tr>
              <td class="left">
                <xsl:choose>
                  <xsl:when test="$smode='showBag'">
                    <a>
                      <xsl:attribute name="href">javascript://</xsl:attribute>
                      <xsl:attribute name="onclick">
                        <xsl:text>javascript:window.open('</xsl:text>
                        <xsl:value-of
                                       select="$xtfURL"/>search?smode=getAddress<xsl:text>','popup','width=500,height=200,resizable=no,scrollbars=no')</xsl:text>
                      </xsl:attribute>   
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="$smode != 'showBag'">
                      <a href="{$xtfURL}{$crossqueryPath}?{$modifyString}">
                        <xsl:text>Modify Search</xsl:text>
                      </a>
                      <b>&#160;&#160;|&#160;&#160;</b>
                    </xsl:if>
                    <a href="{$xtfURL}{$crossqueryPath}">
                      <xsl:text>New Search</xsl:text> 
                    </a><b>&#160;&#160;|&#160;&#160;</b>


                    <a href="search?browse-all=yes">Browse All</a>
                  </xsl:otherwise>
                </xsl:choose>
              </td>

            </tr>
            <xsl:if test="//spelling">
              <tr>
                <td>
                  <xsl:call-template name="did-you-mean">
                    <xsl:with-param name="baseURL" select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                    <xsl:with-param name="spelling" select="//spelling"/>
                  </xsl:call-template>
                </td>
                <td class="right">&#160;</td>
              </tr>
            </xsl:if>
            <tr>
              <td>
                <b>
                  <xsl:value-of select="if($smode='showBag') then 'Bookbag' else 'Results'"/>:</b>&#160;
                <xsl:variable name="items" select="@totalDocs"/>
                <xsl:choose>
                  <xsl:when test="$items = 1">
                    <span id="itemCount">1</span>
                    <xsl:text> Item</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <span id="itemCount">
                      <xsl:value-of select="$items"/>
                    </span>
                    <xsl:text> Items</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="right">
                <xsl:text>Browse by </xsl:text>
                <xsl:call-template name="browseLinks"/>
              </td>
            </tr>
            <!-- Removing Sort BY options, since this guide is relatively simple -->
            <!--  <xsl:if test="docHit">
                     <tr>
                        <td>
                           <form method="get" action="{$xtfURL}{$crossqueryPath}">
                              <b>Sorted by:&#160;</b>
                              <xsl:call-template name="sort.options"/>
                              <xsl:call-template name="hidden.query">
                                 <xsl:with-param name="queryString" select="editURL:remove($queryString, 'sort')"/>
                              </xsl:call-template>
                              <xsl:text>&#160;</xsl:text>
                              <input type="submit" value="Go!"/>
                           </form>
                        </td>
                        <td class="right">
                           <xsl:call-template name="pages"/>
                        </td>
                     </tr>
                  </xsl:if>-->
          </table>
        </div>

        <!-- results -->
        <xsl:choose>
          <xsl:when test="docHit">
            <div class="results">
              <table>
                <tr>
                  <xsl:if test="not($smode='showBag')">
                    <td class="facet">
                      <xsl:apply-templates select="facet[@field='facet-gender']"/>
                      <xsl:apply-templates select="facet[@field='facet-tribe']"/>
                      <xsl:apply-templates select="facet[@field='facet-clan']"/>
                      <xsl:apply-templates select="facet[@field='facet-place']"/>
                    </td>
                  </xsl:if>
                  <td class="docHit">
                    <xsl:apply-templates select="docHit"/>
                  </td>
                </tr>
                <xsl:if test="@totalDocs > $docsPerPage">
                  <tr>
                    <td colspan="2" class="center">
                      <xsl:call-template name="pages"/>
                    </td>
                  </tr>
                </xsl:if>
              </table>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="results">
              <table>
                <tr>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$smode = 'showBag'">
                        <p>Your Bookbag is empty.</p>
                        <p>Click on the 'Add' link next to one or more items in your <a href="{session:getData('queryURL')}">Search Results</a>.</p>
                      </xsl:when>
                      <xsl:otherwise>
                        <p>Sorry, no results...</p>
                        <p>Try modifying your search:</p>
                        <div class="forms">
                          <xsl:choose>
                            <xsl:when test="matches($smode,'advanced')">
                              <xsl:call-template name="simpleForm2"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:call-template name="simpleForm2"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </table>
            </div>
          </xsl:otherwise>
        </xsl:choose>

        <!-- footer -->
        <xsl:copy-of select="$brand.footer"/>

      </body>
    </html>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Bookbag Templates                                                      -->
  <!-- ====================================================================== -->

  <!-- Taking out all reference to the Bookbag in the interface for this guide-->
  <xsl:template name="getAddress" exclude-result-prefixes="#all">
    <html xml:lang="en" lang="en">
      <head>
        <title>E-mail My Bookbag: Get Address</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <xsl:copy-of select="$brand.links"/>
      </head>
      <body>
        <xsl:copy-of select="$brand.header"/>
        <div class="getAddress">
          <h2>E-mail My Bookbag</h2>
          <form action="{$xtfURL}{$crossqueryPath}" method="get">
            <xsl:text>Address: </xsl:text>
            <input type="text" name="email"/>
            <xsl:text>&#160;</xsl:text>
            <input type="reset" value="CLEAR"/>
            <xsl:text>&#160;</xsl:text>
            <input type="submit" value="SUBMIT"/>
            <input type="hidden" name="smode" value="emailFolder"/>
          </form>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="crossQueryResult" mode="emailFolder" exclude-result-prefixes="#all">

    <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>

    <!-- Change the values for @smtpHost and @from to those valid for your domain -->
    <mail:send xmlns:mail="java:/org.cdlib.xtf.saxonExt.Mail" 
         xsl:extension-element-prefixes="mail" 
         smtpHost="mail.amphilsoc.org" 
         useSSL="no" 
		 auth="true"
         from="rshrake@amphilsoc.org"
		 password="10Vienna13"
         to="{$email}" 
         subject="XTF: My Bookbag">
Your XTF Bookbag:
      <xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>
    </mail:send>

    <html xml:lang="en" lang="en">
      <head>
        <title>E-mail My Citations: Success</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <xsl:copy-of select="$brand.links"/>
      </head>
      <body onload="autoCloseTimer = setTimeout('window.close()', 1000)">
        <xsl:copy-of select="$brand.header"/>
        <h1>E-mail My Citations</h1>
        <b>Your citations have been sent.</b>
      </body>
    </html>

  </xsl:template>

  <xsl:template match="savedDoc" mode="emailFolder" exclude-result-prefixes="#all">
    <xsl:variable name="num" select="position()"/>
    <xsl:variable name="id" select="@id"/>
    <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id][1]">
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="url">
        <xsl:value-of select="$xtfURL"/>
        <xsl:choose>
          <xsl:when test="matches(meta/display, 'dynaxml')">
            <xsl:call-template name="dynaxml.url">
              <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="rawDisplay.url">
              <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
Item number <xsl:value-of select="$num"/>: 
      <xsl:value-of select="meta/creator"/>. <xsl:value-of select="meta/tribe"/>. <xsl:value-of select="meta/year"/>. 
[<xsl:value-of select="$url"/>]

    </xsl:for-each>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Browse Template                                                        -->
  <!-- ====================================================================== -->

  <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">

    <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z OTHER'"/>

    <html xml:lang="en" lang="en">
      <head>
        <title>Iroquois Personal Names | American Philosophical Society</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <xsl:copy-of select="$brand.links"/>
        <!-- AJAX support -->
        <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
        <script src="script/yui/connection-min.js" type="text/javascript"/> 
      </head>
      <body>

        <!-- header -->
        <xsl:copy-of select="$brand.header"/>

        <!-- result header -->
        <div class="resultsHeader">
          <table>
            
            <tr>
              <td>
                <b>Browse by:&#160;</b>
                <xsl:choose>
                  <xsl:when test="$browse-tribe">Tribe</xsl:when>
                  <xsl:when test="$browse-clan">Clan</xsl:when>
                  <xsl:when test="$browse-title">Name</xsl:when>
                  <!--<xsl:when test="$browse-creator">Author</xsl:when>-->
                  <xsl:otherwise>All Items</xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="right">
                <a href="{$xtfURL}{$crossqueryPath}">
                  <xsl:text>New Search</xsl:text>
                </a>
                <xsl:if test="$smode = 'showBag'">
                  <xsl:text>&#160;|&#160;</xsl:text>
                  <a href="{session:getData('queryURL')}">
                    <xsl:text>Return to Search Results</xsl:text>
                  </a>
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td>
                <b>Results:&#160;</b>
                <xsl:variable name="items" select="facet/group[docHit]/@totalDocs"/>
                <xsl:choose>
                  <xsl:when test="$items &gt; 1">
                    <xsl:value-of select="$items"/>
                    <xsl:text> Items</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$items"/>
                    <xsl:text> Item</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="right">
                <xsl:text>Browse by </xsl:text>
                <xsl:call-template name="browseLinks"/>
              </td>
            </tr>
            <tr>
              <td colspan="2" class="center">
                <xsl:call-template name="alphaList">
                  <xsl:with-param name="alphaList" select="$alphaList"/>
                </xsl:call-template>
              </td>
            </tr>

          </table>
        </div>

        <!-- results -->
        <div class="results">
          <table>
            <tr>
              <td>
                <xsl:choose>
                  <xsl:when test="$browse-tribe">
                    <xsl:apply-templates select="facet[@field='browse-tribe']/group/docHit"/>
                  </xsl:when>
                  <xsl:when test="$browse-clan">
                    <xsl:apply-templates select="facet[@field='browse-clan']/group/docHit"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="facet[@field='browse-title']/group/docHit"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </table>
        </div>

        <!-- footer -->
        <xsl:copy-of select="$brand.footer"/>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="browseLinks">
    <xsl:choose>
    
      <xsl:when test="$browse-all">
        <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Name</a>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-tribe=first;sort=tribe">Tribe</a>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-clan=first;sort=clan">Clan</a>
      </xsl:when>
      
      <xsl:when test="$browse-tribe">
        <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Name</a>
        <xsl:text> | </xsl:text>
        <xsl:text>Tribe</xsl:text>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-clan=first;sort=clan">Clan</a>
      </xsl:when>
      
      <xsl:when test="$browse-clan">
        <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Name</a>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-tribe=first;sort=tribe">Tribe</a>
        <xsl:text> | </xsl:text>
        <xsl:text>Clan</xsl:text>
      </xsl:when>
      
      <xsl:when test="$browse-title">
        <xsl:text>Name</xsl:text>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-tribe=first;sort=tribe">Tribe</a>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-clan=first;sort=clan">Clan</a>
      </xsl:when>

      <xsl:otherwise>
        <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Name</a>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-tribe=first;sort=tribe">Tribe</a>
        <xsl:text> | </xsl:text>
        <a href="{$xtfURL}{$crossqueryPath}?browse-clan=first;sort=clan">Clan</a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Document Hit Template                                                  -->
  <!-- ====================================================================== -->

  <xsl:template match="docHit" exclude-result-prefixes="#all">

    <xsl:variable name="path" select="@path"/>

    <xsl:variable name="identifier" select="meta/identifier[1]"/>
    <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
    <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>

    <!-- scrolling anchor -->
    <xsl:variable name="anchor">
      <xsl:choose>
        <xsl:when test="$sort = 'creator'">
          <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
        </xsl:when>
        <xsl:when test="$sort = 'tribe'">
          <xsl:value-of select="substring(string(meta/tribe[1]), 1, 1)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <div id="main_{@rank}" class="docHit">    
      <table>




        <!-- Document ID - remove for production -->
        <tr>
          <td class="col1">
            <xsl:text>&#160;</xsl:text>
          </td>
          <td class="col2">
            <b>ID:&#160;&#160;</b>
          </td>
          <td class="col3">
            <xsl:value-of select="$path"/>
          </td>
          <td class="col4">
            <xsl:text>&#160;</xsl:text>
          </td>
        </tr>
        
        <!-- Name -->
         <tr>
          <td class="col1">
            <xsl:text>&#160;</xsl:text>
          </td>
          <td class="col2">
            <b>Name:&#160;&#160;</b>
          </td>
          <td class="col3">
            <xsl:choose>
              <xsl:when test="meta/title">
                <xsl:apply-templates select="meta/title[1]"/>
              </xsl:when>
              <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
          </td>
          <td class="col4">
            <xsl:text>&#160;</xsl:text>
          </td>
        </tr>
        
         <!-- description -> Translation -->
        <tr>
          <td class="col1">
            <xsl:text>&#160;</xsl:text>
          </td>
          <td class="col2">
            <b>Translation:&#160;&#160;</b>
          </td>
          <td class="col3">
            <xsl:if test="meta/description">
              <xsl:apply-templates select="meta/description"/>
            </xsl:if>
          </td>
          <td class="col4">
            <xsl:text>&#160;</xsl:text>
          </td>
        </tr>
        
        <!-- clan -->
        <xsl:if test="meta/clan">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">
              <b>Clan:&#160;&#160;</b>
            </td>
            <td class="col3">
              <xsl:choose>
                <xsl:when test="meta/clan">
                  <xsl:apply-templates select="meta/clan"/>
                </xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if>
        
         <!-- gender -->
        <tr>
          <td class="col1">
            <xsl:text>&#160;</xsl:text>
          </td>
          <td class="col2">
            <b>Gender:&#160;&#160;</b>
          </td>
          <td class="col3">
            <xsl:if test="meta/gender">
              <xsl:apply-templates select="meta/gender"/>
            </xsl:if>
          </td>
          <td class="col4">
            <xsl:text>&#160;</xsl:text>
          </td>
        </tr>
        
        <!-- tribe -->
        <xsl:if test="meta/tribe">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">

              <b>Tribe:&#160;&#160;</b>
            </td>
            <td class="col3">
              <xsl:if test="meta/tribe">
                <xsl:apply-templates select="meta/tribe"/>
              </xsl:if>
            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if>
        
         <!-- place -->
        <xsl:if test="meta/place">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">
              <b>Place:&#160;&#160;</b>
            </td>
            <td class="col3">
              <xsl:choose>
                <xsl:when test="meta/place">
                  <xsl:apply-templates select="meta/place"/>
                </xsl:when>

              </xsl:choose>
            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if>
        
        <!-- Date -->
        <xsl:if test="meta/date">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">
              <b>Date:&#160;&#160;</b>
            </td>
            <td class="col3">
              <xsl:if test="meta/date">
                <xsl:apply-templates select="meta/date"/>
              </xsl:if> 

            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if>
        
        <!-- Grammar -->
        <tr>
          <td class="col1">
            <xsl:text>&#160;</xsl:text>
          </td>
          <td class="col2">
            <b>Grammar:&#160;&#160;</b>
          </td>
          <td class="col3">
            <xsl:if test="meta/format">
              <xsl:apply-templates select="meta/format[1]"/>
            </xsl:if>
          </td>
          <td class="col4">
            <xsl:text>&#160;</xsl:text>
          </td>
        </tr>
        
        <!-- NOTE -->

        <xsl:if test="meta/note">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">
              <b>Note:&#160;&#160;</b>
            </td>
            <td class="col3">
              <xsl:if test="meta/note">
                <xsl:apply-templates select="meta/note"/>
              </xsl:if>
            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if>
        
        <xsl:if test="meta/source">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">
              <b>Source:&#160;&#160;</b>
            </td>
            <td class="col3">
              <xsl:if test="meta/source">
                <xsl:apply-templates select="meta/source"/>
              </xsl:if>
            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if>

<!-- See Also -->
        <xsl:if test="meta/see_also">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">
              <b>See Also:&#160;&#160;</b>
            </td>
            <td class="col3">

              <xsl:apply-templates select="meta/see_also"/>

            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if> 

        <!-- Manuscript Page Number -->
        <xsl:if test="meta/publisher">
          <tr>
            <td class="col1">
              <xsl:text>&#160;</xsl:text>
            </td>
            <td class="col2">
              <b>Mss #:&#160;&#160;</b>
            </td>
            <td class="col3">
              <xsl:if test="meta/publisher">
                <xsl:apply-templates select="meta/publisher"/>
              </xsl:if>
            </td>
            <td class="col4">
              <xsl:text>&#160;</xsl:text>
            </td>
          </tr>
        </xsl:if>

 

        
        <tr>
          <td class="col1">
            <xsl:text>&#160;</xsl:text>
          </td>

          <td class="col4">
            <xsl:text>&#160;</xsl:text>
          </td>
        </tr>
        <tr>
          <td class="col1">
            <xsl:text>&#160;</xsl:text>
          </td>
          <td class="col2">

          </td>
          <td class="col3">

            <xsl:text>&#160;</xsl:text>
          </td>
        </tr>
      </table>
    </div>

  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Snippet Template (for snippets in the full text)                       -->
  <!-- ====================================================================== -->

  <xsl:template match="snippet" mode="text" exclude-result-prefixes="#all">
    <xsl:text>...</xsl:text>
    <xsl:apply-templates mode="text"/>
    <xsl:text>...</xsl:text>
    <br/>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Term Template (for snippets in the full text)                          -->
  <!-- ====================================================================== -->

  <xsl:template match="term" mode="text" exclude-result-prefixes="#all">
    <xsl:variable name="path" select="ancestor::docHit/@path"/>
    <xsl:variable name="display" select="ancestor::docHit/meta/display"/>
    <xsl:variable name="hit.rank">
      <xsl:value-of select="ancestor::snippet/@rank"/>
    </xsl:variable>
    <xsl:variable name="snippet.link">    
      <xsl:call-template name="dynaxml.url">
        <xsl:with-param name="path" select="$path"/>
      </xsl:call-template>
      <xsl:value-of select="concat(';hit.rank=', $hit.rank)"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="ancestor::query"/>
      <xsl:when test="not(ancestor::snippet) or not(matches($display, 'dynaxml'))">
        <span class="hit">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$snippet.link}" class="hit">
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose> 

  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Term Template (for snippets in meta-data fields)                       -->
  <!-- ====================================================================== -->

  <xsl:template match="term" exclude-result-prefixes="#all">
    <xsl:choose>
      <xsl:when test="ancestor::query"/>
      <xsl:otherwise>
        <span class="hit">
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose> 

  </xsl:template>

  <!-- ====================================================================== -->
  <!-- More Like This Template                                                -->
  <!-- ====================================================================== -->

  <!-- results -->
  <xsl:template match="crossQueryResult" mode="moreLike" exclude-result-prefixes="#all">
    <xsl:choose>
      <xsl:when test="docHit">
        <div class="moreLike">
          <ol>
            <xsl:apply-templates select="docHit" mode="moreLike"/>
          </ol>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="moreLike">
          <b>No similar documents found.</b>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- docHit -->
  <xsl:template match="docHit" mode="moreLike" exclude-result-prefixes="#all">

    <xsl:variable name="path" select="@path"/>

    <li>
      <xsl:apply-templates select="meta/creator[1]"/>
      <xsl:text>. </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="matches(meta/display, 'dynaxml')">
              <xsl:call-template name="dynaxml.url">
                <xsl:with-param name="path" select="$path"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="rawDisplay.url">
                <xsl:with-param name="path" select="$path"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates select="meta/title[1]"/>
      </a>
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="meta/year[1]"/>
      <xsl:text>. </xsl:text>
    </li>

  </xsl:template>

</xsl:stylesheet>
