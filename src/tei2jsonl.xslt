<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

<!--    Output will have these columns
act, scene, stage, speaker, speaker_stage, spoke, index

act and scene are hopefully easily understood

stage is actual stage instructions, likely names of roles that should appear on stage

speaker is the role speaking. spoke is what he said. These will always appear together or not at all

speaker_stage is extra instructions to the speaker

index is counter (inside the scene, it resets with each new scene)

Only act, scene and index will always appear.
-->




    <xsl:template name="lg">
        <!--Preserve linebreaks in lg blocks        -->
        <xsl:for-each select="tei:l">
            <xsl:if test="@rend='indent'"><xsl:text>\t</xsl:text></xsl:if>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>\n</xsl:text>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="act_counter">
        <xsl:number level="single"
                    count="/tei:TEI/tei:text/tei:body/tei:div" />
    </xsl:template>


    <xsl:template name="scene_counter">
        <xsl:number level="multiple" count="/tei:TEI/tei:text/tei:body/tei:div/tei:div"/>
    </xsl:template>

    <xsl:template name="scene_index">
        <xsl:number level="any" from="/tei:TEI/tei:text/tei:body/tei:div/tei:div"
                    count="
                        tei:stage |
                        tei:sp/tei:stage |
                        tei:sp/tei:speaker/tei:stage |
                        tei:sp/tei:p/text()[count(preceding-sibling::*)=0] |
                        tei:sp/tei:p/tei:stage |
                        tei:sp/tei:lg" />
    </xsl:template>

    <xsl:variable name="docTitle">
        <xsl:for-each select="/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docTitle/tei:titlePart">
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="year" select="normalize-space(translate(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:byline/text(),'&#xA;',''))"/>


    <xsl:template match="tei:publicationStmt"/>
    <!-- TODO: The title field need all parts of the titlePart -->
    <!-- In the year filed, we need to remove newlines, done with translate(),
         and the also to remove instances of munltiple spaces, done using normalize-space()
    -->
    <xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:stage">{"abrTitle": "<xsl:value-of select="$docTitle"/>", "abrYear": "<xsl:value-of select="$year"/>", "title": "<xsl:value-of select="/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docTitle/tei:titlePart[1]/text()"/>", "year": "<xsl:value-of select="normalize-space(translate(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:byline/text(),'&#xA;',''))"/>", "act": "<xsl:value-of select="../../@n"/>", "act_number": <xsl:call-template name="act_counter"/>, "scene": "<xsl:value-of select="../@n"/>", "scene_number": <xsl:call-template name="scene_counter"/>, "stage": "<xsl:value-of select="normalize-space(.)"/>", "index": <xsl:call-template name="scene_index"/> }<xsl:text>&#xa;</xsl:text></xsl:template>

    <xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:sp/tei:stage">{"abrTitle": "<xsl:value-of select="$docTitle"/>", "abrYear": "<xsl:value-of select="$year"/>", "title": "<xsl:value-of select="/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docTitle/tei:titlePart/text()"/>", "year": "<xsl:value-of select="normalize-space(translate(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:byline/text(),'&#xA;',''))"/>", "act": "<xsl:value-of select="../../../@n"/>", "act_number": <xsl:call-template name="act_counter"/>, "scene": "<xsl:value-of select="../../@n"/>", "scene_number": <xsl:call-template name="scene_counter"/>,  "speaker": "<xsl:value-of select="normalize-space(../tei:speaker/text())"/>", "stage": "<xsl:value-of select="normalize-space(.)"/>", "index": <xsl:call-template name="scene_index"/> }<xsl:text>&#xa;</xsl:text></xsl:template>

    <xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:sp/tei:speaker/tei:stage">{"abrTitle": "<xsl:value-of select="$docTitle"/>", "abrYear": "<xsl:value-of select="$year"/>", "title": "<xsl:value-of select="/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docTitle/tei:titlePart[1]/text()"/>", "year": "<xsl:value-of select="normalize-space(translate(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:byline/text(),'&#xA;',''))"/>", "act": "<xsl:value-of select="../../../../@n"/>", "act_number": <xsl:call-template name="act_counter"/>, "scene": "<xsl:value-of select="../../../@n"/>", "scene_number": <xsl:call-template name="scene_counter"/>, "speaker_stage": "<xsl:value-of select="normalize-space(.)"/>", "speaker": "<xsl:value-of select="normalize-space(../../tei:speaker/text())"/>", "index": <xsl:call-template name="scene_index"/> }<xsl:text>&#xa;</xsl:text></xsl:template>

    <xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:sp/tei:p/text()[count(preceding-sibling::*)=0]">{"abrTitle": "<xsl:value-of select="$docTitle"/>", "abrYear": "<xsl:value-of select="$year"/>", "title": "<xsl:value-of select="/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docTitle/tei:titlePart[1]/text()"/>", "year": "<xsl:value-of select="normalize-space(translate(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:byline/text(),'&#xA;',''))"/>", "act": "<xsl:value-of select="../../../../@n"/>", "act_number": <xsl:call-template name="act_counter"/>, "scene": "<xsl:value-of select="../../../@n"/>", "scene_number": <xsl:call-template name="scene_counter"/>, "speaker": "<xsl:value-of select="normalize-space(../../tei:speaker/text())"/>", "spoke": "<xsl:value-of select="normalize-space(.)"/>", "index": <xsl:call-template name="scene_index"/> }<xsl:text>&#xa;</xsl:text></xsl:template>

    <xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:sp/tei:p/tei:stage">{"abrTitle": "<xsl:value-of select="$docTitle"/>", "abrYear": "<xsl:value-of select="$year"/>", "title": "<xsl:value-of select="/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docTitle/tei:titlePart[1]/text()"/>", "year": "<xsl:value-of select="normalize-space(translate(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:byline/text(),'&#xA;',''))"/>", "act": "<xsl:value-of select="../../../../@n"/>", "act_number": <xsl:call-template name="act_counter"/>, "scene": "<xsl:value-of select="../../../@n"/>", "scene_number": <xsl:call-template name="scene_counter"/>, "speaker_stage": "<xsl:value-of select="normalize-space(.)"/>", "speaker": "<xsl:value-of select="normalize-space(../../tei:speaker/text())"/>", <xsl:if test="position() != last()">"spoke": "<xsl:value-of select="normalize-space(following-sibling::text())"/>",</xsl:if> "index": <xsl:call-template name="scene_index"/> }<xsl:text>&#xa;</xsl:text></xsl:template>

    <xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:sp/tei:lg">{"abrTitle": "<xsl:value-of select="$docTitle"/>", "abrYear": "<xsl:value-of select="$year"/>", "title": "<xsl:value-of select="/tei:TEI/tei:text/tei:front/tei:titlePage/tei:docTitle/tei:titlePart[1]/text()"/>", "year": "<xsl:value-of select="normalize-space(translate(/tei:TEI/tei:text/tei:front/tei:titlePage/tei:byline/text(),'&#xA;',''))"/>", "act": "<xsl:value-of select="../../../../@n"/>", "act_number": <xsl:call-template name="act_counter"/>, "scene": "<xsl:value-of select="../../../@n"/>", "scene_number": <xsl:call-template name="scene_counter"/>, "speaker": "<xsl:value-of select="normalize-space(../tei:speaker/text())"/>", "spoke": "<xsl:call-template name="lg"/>", "index": <xsl:call-template name="scene_index"/> }<xsl:text>&#xa;</xsl:text></xsl:template>

    <!--    There is a built-in template rule to allow recursive processing to continue in the absence of a successful pattern match by an explicit template rule in the stylesheet. This template rule applies to both element nodes and the root node. The following shows the equivalent of the built-in template rule:-->
    <xsl:template match="*|/">
        <xsl:apply-templates/>
    </xsl:template>

    <!--    There is also a built-in template rule for each mode, which allows recursive processing to continue in the same mode in the absence of a successful pattern match by an explicit template rule in the stylesheet. This template rule applies to both element nodes and the root node. The following shows the equivalent of the built-in template rule for mode m.-->
    <xsl:template match="*|/" mode="m">
        <xsl:apply-templates mode="m"/>
    </xsl:template>

    <!--    There is also a built-in template rule for text and attribute nodes that copies text through:-->
    <xsl:template match="text()|@*">
        <!--        <xsl:value-of select="."/>-->
    </xsl:template>

    <!--    The built-in template rule for processing instructions and comments is to do nothing.-->
    <xsl:template match="processing-instruction()|comment()"/>

    <!--    The built-in template rule for namespace nodes is also to do nothing. There is no pattern that can match a namespace node; so, the built-in template rule is the only template rule that is applied for namespace nodes.-->

    <!--    The built-in template rules are treated as if they were imported implicitly before the stylesheet and so have lower import precedence than all other template rules. Thus, the author can override a built-in template rule by including an explicit template rule.-->

</xsl:stylesheet>