/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_get_data.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/27 22:29:13 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/10/22 17:41:43 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

void	ft_get_size(t_vector *size, int *fd)
{
	char	*line;
	int		i;

	i = -1;
	line = NULL;
	if (get_next_line(*fd, &line) == -1)
		ft_error(1);
	if (!line || !ft_check_numbers(line, 0)/* || size->set*/)
		ft_error(2);
	if ((size->x = (double)ft_atoi(line)) < 0.0)
		ft_error(2);
	size->y = 0;
	size->z = 0;
	// size->set = 1;
	free(line);
}

int		ft_get_rgb(char *line)
{
	char	**t;
	int		color;

	color = 0;
	t = ft_strsplit(line, ' ');
	color = (0xff << 24 | ft_atoi(t[2]) << 16 | ft_atoi(t[1]) << 8 | ft_atoi(t[0]));
	free(t[0]);
	free(t[1]);
	free(t[2]);
	free(t);
	return (color);
}

void	ft_get_color(t_color *color, int *fd)
{
	char	*line;
	int		format;
	int		i;

	i = -1;
	format = 0;
	line = NULL;
	if (get_next_line(*fd, &line) == -1)
		ft_error(1);
	format = ft_check_color(line);
	if (format == 0 && ft_check_numbers(line + 2, 2))
		color->c = 0xff << 24 | ft_atoi_base(line + 2, 16);
	else if (format == 1 && ft_check_numbers(line, 1))
		color->c = ft_get_rgb(line);
	else if (format == 2 && ft_check_numbers(line, 0))
		color->c = 0xff << 24 | ft_atoi(line);
	else
		ft_error(2);
	color->r = color->c & 0x000000ff;
	color->g = color->c & 0x0000ff00;
	color->b = color->c & 0x00ff0000;
	free(line);
}

void	ft_get_coord(t_vector *pos, int *fd)
{
	char	**tab;
	char	*line;
	int		i;

	i = -1;
	line = NULL;
	tab = NULL;
	if (get_next_line(*fd, &line) == -1)
		ft_error(1);
	if (!(tab = ft_strsplit(line, ' ')))
		ft_error(3);
	if (!tab[0] || !tab[1] || !tab[2] || !ft_check_numbers(line, 1) || \
															/*pos->set ||*/ tab[3])
		ft_error(2);
	free(line);
	*pos = ft_new_vector(ft_atoi(tab[0]), -ft_atoi(tab[1]), ft_atoi(tab[2]));
	// pos->set = 1;
	while (tab[++i])
		if (tab[i])
			free(tab[i]);
	free(tab);
}

void	ft_get_rotation(t_vector *rotation, int *fd)
{
	char	**tab;
	char	*line;
	int		i;

	i = -1;
	line = NULL;
	tab = NULL;
	if (get_next_line(*fd, &line) == -1)
		ft_error(1);
	if (!(tab = ft_strsplit(line, ' ')))
		ft_error(3);
	if (!tab[0] || !ft_check_numbers(line, 1)/* || rotation->set*/)
		ft_error(2);
	rotation->x = (double)ft_atoi(tab[0]);
	if (tab[1])
		rotation->y = (double)ft_atoi(tab[1]);
	if (tab[2])
		rotation->z = (double)ft_atoi(tab[2]);
	// rotation->set = 1;
	while (tab[++i])
		if (tab[i])
			free(tab[i]);
	free(tab);
	free(line);
}

void	ft_get_intensity(double *intensity, int *fd)
{
	char	*line;

	if (get_next_line(*fd, &line) == -1)
		ft_error(1);
	if (!ft_check_numbers(line, 0))
		ft_error(2);
	*intensity = (double)ft_atoi(line);
	free(line);
}