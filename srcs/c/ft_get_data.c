/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_get_data.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/27 22:29:13 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/20 20:09:51 by eferrand         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

int 	ft_get_size(char **tab, t_vector *size, int *i, int *line)
{
	char	**t;
	int		j;
	int		w;

	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 1))
		ft_error(2, *line);
	w = ft_countwords(tab[*i], ',');
	t = ft_strsplit(tab[*i], ',');
	if (w > 0)
		size->x = ft_atod(t[0]);
	if (w > 1)
		size->y = ft_atod(t[1]);
	if (w > 2)
		size->z = ft_atod(t[2]);
	j = -1;
	while (t[++j])
		free(t[j]);
	free(t);
	while (ft_strcmp(tab[++(*i)], "/size") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_rgb(char *line)
{
	char	**t;
	int		c;

	c = 0;
	t = ft_strsplit(line, ',');
	c = (0xff << 24 | ft_atoi(t[2]) << 16 | ft_atoi(t[1]) << 8 | ft_atoi(t[0]));
	free(t[0]);
	free(t[1]);
	free(t[2]);
	free(t);
	return (c);
}

int		ft_get_color(char **tab, t_color *color, int *i, int *line)
{
	int		format;

	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (ft_comment(tab[*i]))
		ft_error(2, *line);
	format = ft_check_color(tab[*i]);
	if (format == 0 && ft_check_numbers(tab[*i] + 2, 2))
		color->c = 0xff << 24 | ft_atoi_base(tab[*i] + 2, 16);
	else if (format == 1 && ft_check_numbers(tab[*i], 1))
		color->c = ft_get_rgb(tab[*i]);
	else if (format == 2 && ft_check_numbers(tab[*i], 0))
		color->c = 0xff << 24 | ft_atoi(tab[*i]);
	else
		ft_error(2, *line);
	color->r = color->c & 0x000000ff;
	color->g = color->c & 0x0000ff00;
	color->b = color->c & 0x00ff0000;
	while (ft_strcmp(tab[++(*i)], "/color") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_coord(char **tab, t_vector *pos, int *i, int *line)
{
	char	**t;
	int		j;

	j = -1;
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 1))
		ft_error(2, *line);
	t = ft_strsplit(tab[*i], ',');
	if (!t[0] || !t[1] || !t[2] || t[3])
		ft_error(2, *line);
	pos->x = ft_atod(t[0]);
	pos->y = -ft_atod(t[1]);
	pos->z = ft_atod(t[2]);
	while (t[++j])
		free(t[j]);
	free(t);
	while (ft_strcmp(tab[++(*i)], "/position") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_rotation(char **tab, t_vector *rot, int *i, int *line)
{
	char	**t;
	int		j;

	j = -1;
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 1))
		ft_error(2, *line);
	t = ft_strsplit(tab[*i], ',');
	rot->x = ft_atod(t[0]);
	rot->y = ft_atod(t[1]);
	rot->z = ft_atod(t[2]);
	while (t[++j])
		free(t[j]);
	free(t);
	while (ft_strcmp(tab[++(*i)], "/orientation") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_intensity(char **tab, double *intensity, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 0))
		ft_error(2, *line);
	*intensity = ft_atoi(tab[(*i)]);
	while (ft_strcmp(tab[++(*i)], "/intensity") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_reflection(char **tab, double *ref, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 0))
		ft_error(2, *line);
	*ref = ft_atod(tab[(*i)]);
	while (ft_strcmp(tab[++(*i)], "/reflection") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_refraction(char **tab, double *ref, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 0))
		ft_error(2, *line);
	*ref = ft_atod(tab[(*i)]);
	while (ft_strcmp(tab[++(*i)], "/refraction") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_opacity(char **tab, double *transp, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 0))
		ft_error(2, *line);
	*transp = ft_atod(tab[(*i)]);
	while (ft_strcmp(tab[++(*i)], "/opacity") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_specularity(char **tab, double *spec, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 0))
		ft_error(2, *line);
	*spec = ft_atod(tab[(*i)]);
	while (ft_strcmp(tab[++(*i)], "/specularity") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_perturbation(char **tab, double *np, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 0))
		ft_error(2, *line);
	*np = ft_atod(tab[(*i)]);
	while (ft_strcmp(tab[++(*i)], "/perturbation") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

void	ft_get_p_texture(t_object *obj, char *str, int *line)
{
	if (ft_strcmp(str, "chessboard") == 0)
		obj->p_texture = CHESSBOARD;
	else if (ft_strcmp(str, "bricks") == 0)
		obj->p_texture = BRICKS;
	else if (ft_strcmp(str, "wood") == 0)
		obj->p_texture = WOOD;
	else if (ft_strcmp(str, "marble") == 0)
		obj->p_texture = MARBLE;
	else if (ft_strcmp(str, "perlin") == 0)
		obj->p_texture = PERLIN;
	else
		ft_error(2, *line);
}

int		ft_get_texture(char **tab, t_object *obj, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (ft_strcmp(tab[(*i)], "chessboard") == 0 || ft_strcmp(tab[(*i)], "bricks") == 0 || \
		ft_strcmp(tab[(*i)], "perlin") == 0 || ft_strcmp(tab[(*i)], "wood") == 0 || \
											ft_strcmp(tab[(*i)], "marble") == 0)
		ft_get_p_texture(obj, tab[(*i)], line);
	while (ft_strcmp(tab[++(*i)], "/texture") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_get_noise(char **tab, t_noise *noise, int *i, int *line)
{
	char	**t;
	int		j;

	j = -1;
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	t = ft_strsplit(tab[*i], ',');
	if (!t[0] || !t[1] || !t[2] || !t[3] || t[4])
		ft_error(2, *line);
	noise->oct = ft_atod(t[0]);
	noise->freq = ft_atod(t[1]);
	noise->persis = ft_atod(t[2]);
	noise->intensity = ft_atod(t[3]);
	while (t[++j])
		free(t[j]);
	free(t);
	while (ft_strcmp(tab[++(*i)], "/noise") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}

int		ft_comment(char *str)
{
	if (ft_strncmp(str, "!--", 3) == 0 && \
						ft_strncmp(str + (ft_strlen(str) - 2), "--", 2) == 0)
		return (1);
	return (0);
}

int		ft_translation(char **tab, t_vector *pos, int *i, int *line)
{
	t_vector	pos2;
	char	**t;
	int		j;

	j = -1;
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 1))
		ft_error(2, *line);
	t = ft_strsplit(tab[*i], ',');
	if (!t[0] || !t[1] || !t[2] || t[3])
		ft_error(2, *line);
	pos2.x = ft_atod(t[0]);
	pos2.y = ft_atod(t[1]);
	pos2.z = ft_atod(t[2]);
	while (t[++j])
		free(t[j]);
	free(t);
	*pos = ft_add_vector(*pos, pos2);
	while (ft_strcmp(tab[++(*i)], "/translation") != 0)
		if (ft_strcmp(tab[(*i)], "-") != 0)
			ft_error(2, *line);
		else if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
	return (1);
}

int		ft_get_negative(char **tab, int *negative, int *i, int *line)
{
	while (ft_strcmp(tab[++(*i)], "-") == 0)
		*line += 1;
	if (!ft_check_numbers(tab[(*i)], 0))
		ft_error(2, *line);
	*negative = ft_atod(tab[(*i)]);
	while (ft_strcmp(tab[++(*i)], "/negative") != 0)
		if (ft_strcmp(tab[(*i)], "-") == 0)
			*line += 1;
		else
			ft_error(2, *line);
	return (1);
}
